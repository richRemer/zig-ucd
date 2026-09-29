<?xml version="1.0" encoding="utf-8"?>
<stylesheet version="1.0"
    xmlns:ucd="http://www.unicode.org/ns/2003/ucd/1.0"
    xmlns:out="http://remer.us/zrtl/unicode/1.0"
    xmlns="http://www.w3.org/1999/XSL/Transform">

    <output omit-xml-declaration="no" indent="yes" />

    <template match="ucd:ucd">
        <element name="unicode" namespace="http://remer.us/zrtl/unicode/1.0">
            <apply-templates select="ucd:repertoire/ucd:char[@gc='Lu' or @gc='Ll']" />
        </element>
    </template>

    <template match="ucd:char">
        <element name="char" namespace="http://remer.us/zrtl/unicode/1.0">
            <attribute name="code"><value-of select="@cp" /></attribute>
            <attribute name="type"><value-of select="@gc" /></attribute>
        </element>
    </template>

</stylesheet>