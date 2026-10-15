<?xml version="1.0" encoding="utf-8"?>
<stylesheet version="1.0"
    xmlns:ucd="http://www.unicode.org/ns/2003/ucd/1.0"
    xmlns="http://www.w3.org/1999/XSL/Transform">

    <!-- <output omit-xml-declaration="no" indent="yes" /> -->
    <output method="text" />

    <template match="ucd:ucd">
        <text>cp,gc,na,nv&#xa;</text>
        <apply-templates select="ucd:repertoire/ucd:char[@gc='Lu' or @gc='Ll' or @gc='Nd']" />
    </template>

    <template match="ucd:char">
        <value-of select="@cp" />
        <text>,</text>
        <value-of select="@gc" />
        <text>,</text>
        <value-of select="@na" />
        <text>,</text>
        <value-of select="@nv" />
        <text>&#xa;</text>
    </template>

</stylesheet>