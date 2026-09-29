const std = @import("std");
const ucd_url = "https://www.unicode.org/Public/14.0.0/ucdxml/ucd.nounihan.flat.zip";

pub fn build(b: *std.Build) void {
    const ucd_step = b.step("ucd", "Download and format UCD data");
    const run_wget = b.addSystemCommand(&.{ "wget", "-q", ucd_url });
    const run_unzip = b.addSystemCommand(&.{"unzip"});
    const run_xslt = b.addSystemCommand(&.{"xsltproc"});

    const xslt_path = b.path("src/ucd.xslt");
    const zip_path = run_wget.addPrefixedOutputFileArg("-O", "unicode.zip");
    const ucd_path = addOutputFile(run_unzip, "ucd.nounihan.flat.xml");

    run_unzip.addFileArg(zip_path);
    run_xslt.addFileArg(xslt_path);
    run_xslt.addFileArg(ucd_path);

    run_unzip.step.dependOn(&run_wget.step);
    run_xslt.step.dependOn(&run_unzip.step);
    ucd_step.dependOn(&run_xslt.step);
    b.default_step.dependOn(ucd_step);
}

/// Add generated output file to run command without adding it as an argument.
/// The std.Build.Step.Run.addOutputFileArg method adds the output file as an
/// argument to the command, which causes the 'unzip' command to fail.
fn addOutputFile(
    run: *std.Build.Step.Run,
    sub_path: []const u8,
) std.Build.LazyPath {
    const Output = std.Build.Step.Run.Output;
    const b = run.step.owner;
    const output = b.allocator.create(Output) catch @panic("OOM");

    output.* = .{
        .prefix = "",
        .basename = b.dupe(sub_path),
        .generated_file = .{ .step = &run.step },
    };

    if (run.rename_step_with_output_arg) {
        run.setName(b.fmt("{s} ({s})", .{ run.step.name, sub_path }));
    }

    return .{ .generated = .{ .file = &output.generated_file } };
}
