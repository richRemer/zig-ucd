const std = @import("std");
const ucd_url = "https://www.unicode.org/Public/14.0.0/ucdxml/ucd.nounihan.flat.zip";

pub fn build(b: *std.Build) void {
    const ucd_step = b.step("ucd", "Download and format UCD data");
    const run_wget = b.addSystemCommand(&.{ "wget", "-q", ucd_url });
    const run_unzip = b.addSystemCommand(&.{"unzip"});
    const run_xslt = b.addSystemCommand(&.{"xsltproc"});

    const xslt_path = b.path("src/ucd.xslt");
    const dat_path = b.path("src/ucd.dat");
    const zip_path = run_wget.addPrefixedOutputFileArg("-O", "unicode.zip");
    const ucd_path = run_unzip.addPrefixedOutputDirectoryArg("-d", "unicode");
    const xml_path = ucd_path.path(b, "ucd.nounihan.flat.xml");

    run_unzip.addArg("-o");
    run_unzip.addFileArg(zip_path);
    run_xslt.addArg("-o");
    run_xslt.addFileArg(dat_path);
    run_xslt.addFileArg(xslt_path);
    run_xslt.addFileArg(xml_path);

    run_unzip.step.dependOn(&run_wget.step);
    run_xslt.step.dependOn(&run_unzip.step);
    ucd_step.dependOn(&run_xslt.step);
    b.default_step.dependOn(ucd_step);
}
