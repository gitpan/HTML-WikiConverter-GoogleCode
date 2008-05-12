#!perl -T

use warnings;
use strict;
use Data::Dumper;

use Test::More tests => 3;

BEGIN {
	use_ok( 'HTML::WikiConverter');
	use_ok( 'HTML::WikiConverter::GoogleCode');
}


# convert a HTML doc to wiki markup

my @toEscape = qw/
		SqlMapClient
		JBati
		SqlMapClientBuilder
		JavaScript
		NovaJug
		ExampleJSS
		SqlLite
		ExamplesJSS
		SqlMap
		MySql
		SqlMapConfig
		DevGuide
/;

my $wc = new HTML::WikiConverter(
	dialect => 'GoogleCode',
	escape_autolink => \@toEscape,
	escape_entities => 0,
	base_uri => 'http://beavercreekconsulting.com',
	summary => 'Developers Guide V0.2 - jBati usage and examples'
);

my ($which, $html, $expected_wiki) = ('html', '', '');
while(my $line = <DATA>) {
	$which = 'wiki' if $line =~ /^# summary/;  # start of wiki
	if ($which eq 'html') {
		$html .= $line;
	} else {
		$expected_wiki .= $line;
	}
}
my $actual_wiki = $wc->html2wiki($html);

is($actual_wiki, $expected_wiki, 'jBati dev guide');

# the following is the test HTML doc followed expected wiki markup

__DATA__
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
	<META HTTP-EQUIV="CONTENT-TYPE" CONTENT="text/html; charset=windows-1252">
	<TITLE></TITLE>
	<META NAME="GENERATOR" CONTENT="OpenOffice.org 2.4  (Win32)">
	<META NAME="AUTHOR" CONTENT="Marty Kube">
	<META NAME="CREATED" CONTENT="20080417;17354503">
	<META NAME="CHANGED" CONTENT="20080508;11325965">
	<META NAME="CHANGEDBY" CONTENT="Marty Kube">
	<META NAME="CHANGEDBY" CONTENT="Marty Kube">
	<META NAME="CHANGEDBY" CONTENT="Marty Kube">
	<STYLE TYPE="text/css">
	<!--
		@page { size: 8.5in 11in; margin: 0.79in }
		TD P { margin-bottom: 0.08in }
		H1 { margin-bottom: 0.08in }
		H1.western { font-family: "Times New Roman", serif }
		H1.cjk { font-family: "Arial Unicode MS" }
		H1.ctl { font-family: "Tahoma" }
		P { margin-bottom: 0.08in }
		H2 { margin-bottom: 0.08in }
		H2.western { font-family: "Albany", sans-serif; font-size: 14pt; font-style: italic }
		H2.cjk { font-family: "HG Mincho Light J"; font-size: 14pt; font-style: italic }
		H2.ctl { font-family: "Arial Unicode MS"; font-size: 14pt; font-style: italic }
	-->
	</STYLE>
</HEAD>
<BODY LANG="en-US" DIR="LTR">
<H1 CLASS="western"><FONT FACE="Arial, sans-serif">jBati Developers
Guide </FONT>
</H1>
<P><FONT FACE="Arial, sans-serif"><FONT SIZE=4><B>Version 0.2</B></FONT></FONT></P>
<P><FONT FACE="Arial, sans-serif"><FONT SIZE=4><B>2008-05-05</B></FONT></FONT></P>
<P><FONT FACE="Arial, sans-serif"><FONT SIZE=4><B>Marty Kube</B></FONT></FONT></P>
<HR>
<H2 CLASS="western"><A NAME="Introduction"></A><FONT FACE="Arial, sans-serif">Introduction</FONT></H2>
<P><FONT FACE="Arial, sans-serif"><A HREF="http://code.google.com/p/jbati/">jBati</A>
is a Object Relational Mapping (<A HREF="http://en.wikipedia.org/wiki/Object_Relational_Mapping">ORM</A>)
framework for JavaScript programs running on the <A HREF="http://www.aptana.com/jaxer/">Jaxer</A>
platform. JavaScript has primarily been a browser scripting language.
Lately, JavaScript has been gaining traction as a server side
development language. Once JavaScript moves to the server side,
interaction with a database becomes an important component of most
applications. Developers working on the server side use ORM
frameworks to significantly improve development speed and quality as
compared to the alternative of ad hoc persistence frameworks or SQL
embedded within application code. jBati aims to fulfill the need for
a JavaScript ORM solution on the Jaxer platform. </FONT>
</P>
<P><A NAME="Introduction2"></A><FONT FACE="Arial, sans-serif">jBati
is targeted to the Jaxer platform. Jaxer is an AJAX web application
development platform that uses JavaScript on the server side. Jaxer
allows development of an entire application in JavaScript and
supports database interaction in JavaScript. </FONT>
</P>
<P><FONT FACE="Arial, sans-serif">There is a spectrum of approaches
in ORM frameworks. In the Java world, two contrasting examples are
<A HREF="http://www.hibernate.org/">Hibernate</A> and <A HREF="http://ibatis.apache.org/">iBATIS</A>.
Both of these are reasonable approaches; either one might be suitable
depending on your needs (here are some recommendations on <A HREF="http://f1.grp.yahoofs.com/v1/MDH8R9hmkRTGEMSze8SrVwVG5VWGtrX42M1PdTBIrDOGp6EFlLQq2eGMlwzU7Y6VrFQrHmNvJTjGCnfg_tMd6p6HmKWR07I/NovaJug%202007%20Persistence%20Choices.pdf">choosing</A>
an ORM framework). </FONT>
</P>
<P><FONT FACE="Arial, sans-serif">Hibernate falls into the
traditional ORM framework camp, which are frameworks that pretty much
handle all of the object life cycle details for you. You define
object attributes and relationships and the framework generates SQL
and often DDL, decides when object state has changed and a database
update is needed, and generally does the right thing. The database
side of the persistence model is very much encapsulated. </FONT>
</P>
<P><FONT FACE="Arial, sans-serif">iBATIS falls into the SQL mapper
category. For this category of frameworks, you define SQL statements
and a mapping to objects and object attributes, and the framework
executes the SQL and populates objects. In this case, the framework
user generally handles more details of the object life cycle. </FONT>
</P>
<P><FONT FACE="Arial, sans-serif">Both approaches have merit and
choosing the right one depends on the situation. SQL mappers
generally work better when the application developer has less control
over the database model or when the object instances have a complex
relationship to database tables. </FONT>
</P>
<P><FONT FACE="Arial, sans-serif">jBati is a SQL mapper framework. If
a SQL mapper is the right choice for you, read on... </FONT>
</P>
<P><FONT FACE="Arial, sans-serif">jBati is modeled on iBATIS, which
is a widely used Java ORM framework. The intent for jBati is that the
configuration and API be a direct match to iBATIS. The differences
are driven by what makes sense for the implementation language, which
is Java for iBATIS and JavaScript for jBati. Also, jBati is a newer
project and will generally have less features (at least for now). </FONT>
</P>
<P><FONT FACE="Arial, sans-serif">The remainder of this document
covers the two main task that must be accomplished to use a SQL
mapper ORM framework: the configuration to specify SQL and it's
relationship to domain objects, and the API that is used to access
domain objects in application code. </FONT>
</P>
<H2 CLASS="western"><FONT FACE="Arial, sans-serif">Background</FONT></H2>
<P><FONT FACE="Arial, sans-serif">This guide will make the most sense
if you are familiar with Jaxer and iBATIS. </FONT>
</P>
<P><FONT FACE="Arial, sans-serif">Setting up the framework requires
that the jBati library be loaded at the appropriate points the Jaxer
page life cycle. Check out the Jaxer documentation on <A HREF="http://www.aptana.com/node/224">callbacks</A>
and using JavaScript libraries <A HREF="http://www.aptana.com/node/202">during
callbacks</A>. </FONT>
</P>
<P><FONT FACE="Arial, sans-serif">Likewise, it might be worthwhile to
take a look at the iBATIS <A HREF="http://ibatisnet.sourceforge.net/Tutorial.html">tutorial</A>,
or if you have a little more time, the iBATIS Developer <A HREF="http://ibatisnet.sourceforge.net/DevGuide/">Guide</A>.
These documents show how to use a SQL mapping framework and the
philosophy that jBati was built on.</FONT></P>
<H2 CLASS="western"><FONT FACE="Arial, sans-serif">Installation</FONT></H2>
<P><FONT FACE="Arial, sans-serif">Obtain the latest distribution from
the project home page (<A HREF="http://code/google.com/p/jbati">http://code/google.com/p/jbati</A>).
The library is comprised of two JavaScript files, namely
</FONT><CODE>jbati-client.js</CODE> <FONT FACE="Arial, sans-serif">and
</FONT><CODE>jbati-server.js</CODE><FONT FACE="Arial, sans-serif">.
The client file is intended to be executed in the browser, while the
server file is intended to be executed on a Jaxer server.</FONT></P>
<P><FONT FACE="Arial, sans-serif">A few more items to note before we
move on to an example. The jBati API is available at
<A HREF="http://beavercreekconsulting.com/jbati/apidocs/">http://beavercreekconsulting.com/jbati/apidocs</A>
and in the distribution files. Also, jBati is a young and fast moving
project; check the Release Notes for the availability of specific
features.</FONT></P>
<P><FONT FACE="Arial, sans-serif">To make good use of jBati, you'll
need a database, SQL, and some JavaScript objects that you want to
put together in a useful manner. You'll have to write the
configuration files which contain the SQL and the mapping to
JavaScript objects/attributes. Then, you'll include the jBati library
in you application code and use the API to fetch and persist
JavaScript objects in your database. To make this clear, we'll start
with an example and then follow up with reference information.</FONT></P>
<H2 CLASS="western"><FONT FACE="Arial, sans-serif">Example</FONT></H2>
<P><FONT FACE="Arial, sans-serif">The example discussed here is
available in the distribution under <CODE>examples/jcs</CODE>. This
example is a HTML page that executes a cycle of CRUD operations on a
<CODE>Person</CODE> object. The attributes of the <CODE>Person</CODE>
are first read from a HTML table and the <CODE>Person</CODE> object
is inserted into the database. Then the same person is read back to
populate another HTML table. <CODE>Person</CODE> attributes to update
the in the database are read from another table, and finally the
<CODE>Person</CODE> is deleted from the database. The CRUD cycle can
be executed in a sequential fashion, or, with asynchronous calls to
the server. Here is a screen shot of <CODE>jbati-client-side.html</CODE>
in action:</FONT></P>
<P><IMG SRC="img/jbati-client-side.html.png" NAME="graphics1" ALIGN=LEFT WIDTH=454 HEIGHT=466 BORDER=0><BR CLEAR=LEFT><BR><BR>
</P>
<P><BR><BR>
</P>
<P><FONT FACE="Arial, sans-serif">The top portion of
<CODE>jbati-client-side.html</CODE> shows the pieces that are need:</FONT></P>
<P><BR><BR>
</P>
<PRE>001 &lt;html&gt;
002   &lt;head&gt;
003     &lt;title&gt;jBati Examples - jBati Client Side&lt;/title&gt;
004 
005     &lt;!--
006       -- An example of jBati client side usage
007       --&gt;
008     
009     &lt;!-- load jBati server side framework --&gt;
010     &lt;script src=&quot;../../lib/jbati-server.js&quot; runat=&quot;server&quot; autoload=&quot;true&quot;&gt;&lt;/script&gt;
011     
012     &lt;!-- load jBati client side framework --&gt;
013     &lt;script src=&quot;../../lib/jbati-client.js&quot;&gt;&lt;/script&gt;
014     
015     &lt;!-- Domain objects, expose on client and server --&gt;
016     &lt;script src=&quot;user-objects.js&quot; runat=&quot;both&quot; autoload=&quot;true&quot;&gt;&lt;/script&gt;
017     
018     &lt;!-- Domain objects ORM mapping, needed only on server --&gt;
019     &lt;script src=&quot;user-object-maps.js&quot; runat=&quot;server&quot; autoload=&quot;true&quot;&gt;&lt;/script&gt;</PRE><P>
<FONT FACE="Arial, sans-serif">On line 10, the server side of the
jBati framework is imported into the server execution context. The
Jaxer attributes are important here; both <CODE>runat=&quot;server&quot;</CODE>
and <CODE>autoload=&quot;true&quot;</CODE> are necessary. Likewise,
the client side of the jBati framework, which runs in the browser, is
loaded on line 13.</FONT></P>
<P><FONT FACE="Arial, sans-serif">You'll need to supply equivalent
scripts for the next two included script. The first script script
defines domain objects and the second script tells jBati to load your
configuration files which contains SQL and the mapping to objects. </FONT>
</P>
<P><FONT FACE="Arial, sans-serif">The domain objects need to be
available on the client, where you'll use them, and on the server
side, where jBati will take care of persistence operations. On line
16, the domain objects are imported into both the client and server
context with the script attributes of <CODE>runat=&quot;both&quot;</CODE>
and <CODE>autoload=&quot;true&quot;</CODE>. Here's a listing of
<CODE>user-objects.js</CODE>:</FONT></P>
<PRE>001 //
002 // User domain objects
003 //
004 (function () {
005 
006     if(typeof Examples == 'undefined') {
007             Examples = {};
008     }
009 
010     Examples.Domain = {};
011     Examples.Domain.Person = function () {};
012 
013  
014 })();</PRE><P>
<FONT FACE="Arial, sans-serif"><CODE>Person</CODE> is a pretty
lightweight domain object. In fact, if you find yourself declaring
this type of object, you can just use the JavaScript <CODE>Object</CODE>
class in your object mapping. In any case, here, the domain objects
are kept in a namespace object (<CODE>Examples</CODE>). Executing
this code is need during server callbacks to populate the global
variable <CODE>Examples</CODE> and thus the script attribute
<CODE>autoload=&quot;true&quot;</CODE> is required for this example.
On the other hand, if you're not using a namespace, the autoload
attribute is not needed.</FONT></P>
<P><FONT FACE="Arial, sans-serif">The next bit of scripting you need
to provide tells jBati to load your SQL and object mapping files. On
line 19 <CODE>user-object-maps.js</CODE> is loaded. Here's a listing:</FONT></P>
<PRE>001 //
002 // Load the SqlMapConfig file
003 //
004 (function () {
005 
006     var path = Jaxer.Dir.resolvePath('../jcs/sqlMapConfig.xml');
007     var url = Jaxer.Dir.pathToUrl(path);
008     JBati.Server.SqlMapClientBuilder.buildSqlMapClient(url, 'ExamplesJSS');
009  
010 })();</PRE><P>
<FONT FACE="Arial, sans-serif">Loading the object mapping
configuration is a server side only operation as you likely don't
want to expose this information on the Internet. Therefore, the
including script tag is <CODE>run=&quot;server&quot;</CODE>. The path
to the file on line 6 is a file system path, relative in this case,
which gets resolved to a file protocol URL on line 7. Line 8 invokes
the jBati call to parse the configuration file and build a jBati
client.</FONT></P>
<P><FONT FACE="Arial, sans-serif">In this example, the jBati client
is used on the browser side. The second parameter to
<CODE>buildSqlMapClient()</CODE>, <CODE>'ExampleJSS'</CODE>, names
the client for later retrieval by JavaScript executing in the
browser. Naming the client is optional and needed only if you're
using multiple database connections. The unnamed, or default, client
uses the Jaxer application database connection.</FONT></P>
<P><FONT FACE="Arial, sans-serif">The next item needed is the jBati
configuration files. The first file, <CODE>sqlMapConfig.xml</CODE>,
contains a sqlMapConfig document:</FONT></P>
<PRE>001 &lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot; ?&gt;
002 &lt;!DOCTYPE sqlMapConfig
003     PUBLIC &quot;-//ibatis.apache.org//DTD SQL Map Config 2.0//EN&quot;
004     &quot;http://ibatis.apache.org/dtd/sql-map-config-2.dtd&quot;&gt;
005 
006 &lt;sqlMapConfig&gt;
007     &lt;sqlMap resource=&quot;person.xml&quot;/&gt;
008 &lt;/sqlMapConfig&gt;</PRE><P>
<FONT FACE="Arial, sans-serif">This file is pretty light weight in
the current version. The only interesting part is loading a sqlMap
XML file named <CODE>person.xml</CODE>. The resource attribute is a
path relative to the sqlMapConfig file. In future releases, this file
will contain configuration specific to a database connection (such as
database type, SqlLite or MySql, and connection credentials). A real
application would include several sqlMap files, with files split per
domain object for easier maintenance.</FONT></P>
<P><FONT FACE="Arial, sans-serif">Finally, <CODE>person.xml</CODE>
holds the SQL and object mapping:</FONT></P>
<PRE>001 &lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot; ?&gt;
002 &lt;!DOCTYPE sqlMap
003     PUBLIC &quot;-//ibatis.apache.org//DTD SQL Map 2.0//EN&quot;
004     &quot;http://ibatis.apache.org/dtd/sql-map-2.dtd&quot;&gt;
005 
006 &lt;sqlMap&gt;
007 
008     &lt;!-- Use scalar type as parameter and allow results to
009     be auto-mapped results to Person object --&gt;
010     &lt;select id=&quot;getPerson&quot; resultClass=&quot;Examples.Domain.Person&quot;&gt;
011             SELECT 
012             PER_ID                  as id,
013             PER_FIRST_NAME  as firstName,
014             PER_LAST_NAME   as lastName,
015             PER_BIRTH_DATE  as birthDate,
016             PER_WEIGHT_KG   as weightInKilograms,
017             PER_HEIGHT_M            as heightInMeters
018             FROM person 
019             WHERE PER_ID = #value#
020     &lt;/select&gt;
021     
022     &lt;!-- Use Person object properties as parameters for insert.  Each of the
023     parameters in the #hash# symbols is a Person property.  --&gt;
024     &lt;insert id=&quot;insertPerson&quot;&gt;
025             INSERT INTO person (
026                     PER_ID, PER_FIRST_NAME, PER_LAST_NAME, 
027                     PER_BIRTH_DATE, PER_WEIGHT_KG, PER_HEIGHT_M
028             ) VALUES (
029                     #id#, #firstName#, #lastName#, 
030                     #birthDate#, #weightInKilograms#, #heightInMeters#
031             )
032     &lt;/insert&gt;
033     
034     &lt;!-- Use Person object properties as parameters for update. Each of the
035     parameters in the #hash# symbols is a Person property.  --&gt;
036     &lt;update id=&quot;updatePerson&quot;&gt;
037             UPDATE person
038             SET PER_FIRST_NAME = #firstName#, 
039             PER_LAST_NAME = #lastName#, 
040             PER_BIRTH_DATE = #birthDate#, 
041             PER_WEIGHT_KG = #weightInKilograms#, 
042             PER_HEIGHT_M = #heightInMeters#
043             WHERE PER_ID = #id#
044     &lt;/update&gt;
045     
046     &lt;!-- Use Person object &quot;id&quot; properties as parameters for delete. Each of the
047     parameters in the #hash# symbols is a Object property.  --&gt;
048     &lt;delete id=&quot;deletePerson&quot;&gt;
049             DELETE FROM person 
050             WHERE PER_ID = #id#
051     &lt;/delete&gt;
052 
053 &lt;/sqlMap&gt;</PRE><P>
<FONT FACE="Arial, sans-serif">This file is a pretty direct copy from
the iBATIS tutorials. This is noted here, not just to give the due
credit, but to also point out a fundamental design decision. The
jBati configuration documents conform to the iBATIS DTD. There are
many elements that are not in fact supported by jBati. However, the
aim is to allow validation of the XML and support similar semantics.</FONT></P>
<P><FONT FACE="Arial, sans-serif">All of the elements are in place,
so let's look at some code to see how the sqlMap is used. The select
statement on lines 8-20 is executed with the following code. First, a
jBati client is fetched:</FONT></P>
<PRE STYLE="margin-bottom: 0.2in">        var client = new Jbati.Client.SqlMapClient('ExamplesJSS');</PRE><P>
<FONT FACE="Arial, sans-serif">Then, a single <CODE>Person</CODE>
object is fetched:</FONT></P>
<PRE STYLE="margin-bottom: 0.2in">        var p = client.queryForObject('getPerson', 1);</PRE><P>
<FONT FACE="Arial, sans-serif">The parameter <CODE>'getPerson'</CODE>
is the id attribute of the XML select element and is used to identify
which SQL statement is to be executed. The SQL has replacement tokens
such as the <CODE>#id#</CODE> parameter on line 19 of the sqlMap
document. The replacement token is typical substituted with similarly
named property of the passed in parameter object. In this case, since
the parameter is a single valued, or scalar, parameter, jBati uses it
irregardless of the name of the replacement token.</FONT></P>
<P><FONT FACE="Arial, sans-serif">The select statement is executed
and jBati then creates a new instance of <CODE>Person</CODE> and
populates properties of the <CODE>Person</CODE> object with the
result set. The SQL statement has column aliases for the columns.
This allows mapping of table columns to object properties.</FONT></P>
<P><FONT FACE="Arial, sans-serif">Executing the insert statement
shows how to use a object as the parameter object. For example, if we
have a <CODE>Person</CODE> object:</FONT></P>
<PRE>var p = new Examples.domain.Person();
p.id: 1001, 
p.firstName = 'Bob',
p.lastName ='Jones',
p.birthDate = new Date(1975, 2, 13),
p.weightInKilograms = 82.45,
p.heightInMeters = 1.88</PRE><P>
<FONT FACE="Arial, sans-serif">This object can be used to fill in the
values for the <CODE>updatePerson</CODE> SQL statement:</FONT></P>
<PRE STYLE="margin-bottom: 0.2in">client.update('updatePerson', p);</PRE><P>
<FONT FACE="Arial, sans-serif">This wraps up the first example.</FONT></P>
<P><FONT FACE="Arial, sans-serif">It is worth noting that jBati
supports one other main usage pattern, which is jBati on the server
side. In this pattern, you would write server side code that
interacts with jBati, and then also write a server side data access
API with methods marked for Jaxer to proxy. For an example of this
pattern, see examples/jss.</FONT></P>
<P><FONT FACE="Arial, sans-serif">The next sections document the
sqlMapConfig and sqlMap XML documents.</FONT></P>
<H2 CLASS="western"><FONT FACE="Arial, sans-serif">SqlMapConfig</FONT></H2>
<P><FONT FACE="Arial, sans-serif">The sqlMapConfig element is loaded
with the call:</FONT></P>
<PRE STYLE="margin-bottom: 0.2in">Jbati.Server.SqlMapClientBuilder.buildSqlMapClient(url).  </PRE><P>
<FONT FACE="Arial, sans-serif">The argument url must be a file
protocol URL.</FONT></P>
<P><FONT FACE="Arial, sans-serif">The sqlMapConfig XML document
should conform to the iBATIS sqlMapConfig DTD
(<A HREF="http://ibatis.apache.org/dtd/sql-map-config-2.dtd">http://ibatis.apache.org/dtd/sql-map-config-2.dtd</A>).
Many elements in the DTD are not supported and will be ignored. The
supported elements are listed in the following table:</FONT></P>
<TABLE WIDTH=100% BORDER=1 BORDERCOLOR="#000000" CELLPADDING=4 CELLSPACING=0 STYLE="page-break-inside: avoid">
	<COL WIDTH=56*>
	<COL WIDTH=43*>
	<COL WIDTH=157*>
	<TR VALIGN=TOP>
		<TD WIDTH=22% BGCOLOR="#cccccc">
			<P><FONT FACE="Arial, sans-serif"><B>Element</B></FONT></P>
		</TD>
		<TD WIDTH=17% BGCOLOR="#cccccc">
			<P><FONT FACE="Arial, sans-serif"><B>Attribute</B></FONT></P>
		</TD>
		<TD WIDTH=61% BGCOLOR="#cccccc">
			<P><FONT FACE="Arial, sans-serif"><B>Description</B></FONT></P>
		</TD>
	</TR>
	<TR VALIGN=TOP>
		<TD WIDTH=22%>
			<P><FONT FACE="Arial, sans-serif">sqlMapConfig</FONT></P>
		</TD>
		<TD WIDTH=17%>
			<P><BR>
			</P>
		</TD>
		<TD WIDTH=61%>
			<P><BR>
			</P>
		</TD>
	</TR>
	<TR VALIGN=TOP>
		<TD WIDTH=22%>
			<P><FONT FACE="Arial, sans-serif">SqlMap</FONT></P>
		</TD>
		<TD WIDTH=17%>
			<P><FONT FACE="Arial, sans-serif">resource</FONT></P>
		</TD>
		<TD WIDTH=61%>
			<P><FONT FACE="Arial, sans-serif">File system path to a sqlMap
			file. Relative paths are relative to the location of the
			sqlMapConfig file.</FONT></P>
		</TD>
	</TR>
</TABLE>
<P><BR><BR>
</P>
<H2 CLASS="western"><FONT FACE="Arial, sans-serif">SqlMap</FONT></H2>
<P><FONT FACE="Arial, sans-serif">Similar to the sqlMapConfig
document, the sqlMap XML document should conform to the iBATIS sqlMap
DTD (<A HREF="http://ibatis.apache.org/dtd/sql-map-2.dtd">http://ibatis.apache.org/dtd/sql-map-2.dtd</A>).</FONT></P>
<P><BR><BR>
</P>
<P><FONT FACE="Arial, sans-serif">Many elements in the DTD are not
supported and will be ignored. The supported elements and attributes
are listed in the following table:</FONT></P>
<TABLE WIDTH=100% BORDER=1 BORDERCOLOR="#000000" CELLPADDING=4 CELLSPACING=0 STYLE="page-break-inside: avoid">
	<COL WIDTH=56*>
	<COL WIDTH=43*>
	<COL WIDTH=157*>
	<TR VALIGN=TOP>
		<TD WIDTH=22% BGCOLOR="#cccccc">
			<P><FONT FACE="Arial, sans-serif"><B>Element</B></FONT></P>
		</TD>
		<TD WIDTH=17% BGCOLOR="#cccccc">
			<P><FONT FACE="Arial, sans-serif"><B>Attribute</B></FONT></P>
		</TD>
		<TD WIDTH=61% BGCOLOR="#cccccc">
			<P><FONT FACE="Arial, sans-serif"><B>Description</B></FONT></P>
		</TD>
	</TR>
	<TR VALIGN=TOP>
		<TD WIDTH=22%>
			<P><FONT FACE="Arial, sans-serif">sqlMap</FONT></P>
		</TD>
		<TD WIDTH=17%>
			<P><BR>
			</P>
		</TD>
		<TD WIDTH=61%>
			<P><BR>
			</P>
		</TD>
	</TR>
	<TR VALIGN=TOP>
		<TD WIDTH=22%>
			<P><FONT FACE="Arial, sans-serif">select</FONT></P>
		</TD>
		<TD WIDTH=17%>
			<P><BR>
			</P>
		</TD>
		<TD WIDTH=61%>
			<P><FONT FACE="Arial, sans-serif">Contains a SQL select statement
			as CDATA.</FONT></P>
		</TD>
	</TR>
	<TR VALIGN=TOP>
		<TD WIDTH=22%>
			<P><FONT FACE="Arial, sans-serif">select</FONT></P>
		</TD>
		<TD WIDTH=17%>
			<P><FONT FACE="Arial, sans-serif">id</FONT></P>
		</TD>
		<TD WIDTH=61%>
			<P><FONT FACE="Arial, sans-serif">The is by which SQL statements
			are referred to. All API calls that execute DML require this as a
			parameter.</FONT></P>
		</TD>
	</TR>
	<TR VALIGN=TOP>
		<TD WIDTH=22%>
			<P><FONT FACE="Arial, sans-serif">select</FONT></P>
		</TD>
		<TD WIDTH=17%>
			<P><FONT FACE="Arial, sans-serif">resultClass</FONT></P>
		</TD>
		<TD WIDTH=61%>
			<P><FONT FACE="Arial, sans-serif">The class from which an object
			instances will be created and populated with the result set
			values.</FONT></P>
		</TD>
	</TR>
	<TR VALIGN=TOP>
		<TD WIDTH=22%>
			<P><FONT FACE="Arial, sans-serif">update</FONT></P>
		</TD>
		<TD WIDTH=17%>
			<P><BR>
			</P>
		</TD>
		<TD WIDTH=61%>
			<P><FONT FACE="Arial, sans-serif">Contains a SQL update statement
			as CDATA.</FONT></P>
		</TD>
	</TR>
	<TR VALIGN=TOP>
		<TD WIDTH=22%>
			<P><FONT FACE="Arial, sans-serif">update</FONT></P>
		</TD>
		<TD WIDTH=17%>
			<P><FONT FACE="Arial, sans-serif">id</FONT></P>
		</TD>
		<TD WIDTH=61%>
			<P><FONT FACE="Arial, sans-serif">The is by which SQL statements
			are referred to. All API calls that execute DML require this as a
			parameter.</FONT></P>
		</TD>
	</TR>
	<TR VALIGN=TOP>
		<TD WIDTH=22%>
			<P><FONT FACE="Arial, sans-serif">insert</FONT></P>
		</TD>
		<TD WIDTH=17%>
			<P><BR>
			</P>
		</TD>
		<TD WIDTH=61%>
			<P><FONT FACE="Arial, sans-serif">Contains a SQL insert statement
			as CDATA.</FONT></P>
		</TD>
	</TR>
	<TR VALIGN=TOP>
		<TD WIDTH=22%>
			<P><FONT FACE="Arial, sans-serif">insert</FONT></P>
		</TD>
		<TD WIDTH=17%>
			<P><FONT FACE="Arial, sans-serif">id</FONT></P>
		</TD>
		<TD WIDTH=61%>
			<P><FONT FACE="Arial, sans-serif">The is by which SQL statements
			are referred to. All API calls that execute DML require this as a
			parameter.</FONT></P>
		</TD>
	</TR>
	<TR VALIGN=TOP>
		<TD WIDTH=22%>
			<P><FONT FACE="Arial, sans-serif">delete</FONT></P>
		</TD>
		<TD WIDTH=17%>
			<P><BR>
			</P>
		</TD>
		<TD WIDTH=61%>
			<P><FONT FACE="Arial, sans-serif">Contains a SQL delete statement
			as CDATA.</FONT></P>
		</TD>
	</TR>
	<TR VALIGN=TOP>
		<TD WIDTH=22%>
			<P><FONT FACE="Arial, sans-serif">delete</FONT></P>
		</TD>
		<TD WIDTH=17%>
			<P><FONT FACE="Arial, sans-serif">id</FONT></P>
		</TD>
		<TD WIDTH=61%>
			<P><FONT FACE="Arial, sans-serif">The is by which SQL statements
			are referred to. All API calls that execute DML require this as a
			parameter.</FONT></P>
		</TD>
	</TR>
</TABLE>
<P><BR><BR>
</P>
<P><BR><BR>
</P>
</BODY>
</HTML>
# summary Developers Guide V0.2 - jBati usage and examples

= jBati Developers Guide =

*Version 0.2*

*2008-05-05*

*Marty Kube*

----

== Introduction ==

[http://code.google.com/p/jbati/ jBati] is a Object Relational Mapping ([http://en.wikipedia.org/wiki/Object_Relational_Mapping ORM]) framework for !JavaScript programs running on the [http://www.aptana.com/jaxer/ Jaxer] platform. !JavaScript has primarily been a browser scripting language. Lately, !JavaScript has been gaining traction as a server side development language. Once !JavaScript moves to the server side, interaction with a database becomes an important component of most applications. Developers working on the server side use ORM frameworks to significantly improve development speed and quality as compared to the alternative of ad hoc persistence frameworks or SQL embedded within application code. jBati aims to fulfill the need for a !JavaScript ORM solution on the Jaxer platform.

jBati is targeted to the Jaxer platform. Jaxer is an AJAX web application development platform that uses !JavaScript on the server side. Jaxer allows development of an entire application in !JavaScript and supports database interaction in !JavaScript.

There is a spectrum of approaches in ORM frameworks. In the Java world, two contrasting examples are [http://www.hibernate.org/ Hibernate] and [http://ibatis.apache.org/ iBATIS]. Both of these are reasonable approaches; either one might be suitable depending on your needs (here are some recommendations on [http://f1.grp.yahoofs.com/v1/MDH8R9hmkRTGEMSze8SrVwVG5VWGtrX42M1PdTBIrDOGp6EFlLQq2eGMlwzU7Y6VrFQrHmNvJTjGCnfg_tMd6p6HmKWR07I/NovaJug 2007 Persistence Choices.pdf choosing] an ORM framework).

Hibernate falls into the traditional ORM framework camp, which are frameworks that pretty much handle all of the object life cycle details for you. You define object attributes and relationships and the framework generates SQL and often DDL, decides when object state has changed and a database update is needed, and generally does the right thing. The database side of the persistence model is very much encapsulated.

iBATIS falls into the SQL mapper category. For this category of frameworks, you define SQL statements and a mapping to objects and object attributes, and the framework executes the SQL and populates objects. In this case, the framework user generally handles more details of the object life cycle.

Both approaches have merit and choosing the right one depends on the situation. SQL mappers generally work better when the application developer has less control over the database model or when the object instances have a complex relationship to database tables.

jBati is a SQL mapper framework. If a SQL mapper is the right choice for you, read on...

jBati is modeled on iBATIS, which is a widely used Java ORM framework. The intent for jBati is that the configuration and API be a direct match to iBATIS. The differences are driven by what makes sense for the implementation language, which is Java for iBATIS and !JavaScript for jBati. Also, jBati is a newer project and will generally have less features (at least for now).

The remainder of this document covers the two main task that must be accomplished to use a SQL mapper ORM framework: the configuration to specify SQL and it's relationship to domain objects, and the API that is used to access domain objects in application code.

== Background ==

This guide will make the most sense if you are familiar with Jaxer and iBATIS.

Setting up the framework requires that the jBati library be loaded at the appropriate points the Jaxer page life cycle. Check out the Jaxer documentation on [http://www.aptana.com/node/224 callbacks] and using !JavaScript libraries [http://www.aptana.com/node/202 during callbacks].

Likewise, it might be worthwhile to take a look at the iBATIS [http://ibatisnet.sourceforge.net/Tutorial.html tutorial], or if you have a little more time, the iBATIS Developer [http://ibatisnet.sourceforge.net/DevGuide/ Guide]. These documents show how to use a SQL mapping framework and the philosophy that jBati was built on.

== Installation ==

Obtain the latest distribution from the project home page (http://code/google.com/p/jbati). The library is comprised of two !JavaScript files, namely `jbati-client.js` and `jbati-server.js`. The client file is intended to be executed in the browser, while the server file is intended to be executed on a Jaxer server.

A few more items to note before we move on to an example. The jBati API is available at [http://beavercreekconsulting.com/jbati/apidocs/ http://beavercreekconsulting.com/jbati/apidocs] and in the distribution files. Also, jBati is a young and fast moving project; check the Release Notes for the availability of specific features.

To make good use of jBati, you'll need a database, SQL, and some !JavaScript objects that you want to put together in a useful manner. You'll have to write the configuration files which contain the SQL and the mapping to !JavaScript objects/attributes. Then, you'll include the jBati library in you application code and use the API to fetch and persist !JavaScript objects in your database. To make this clear, we'll start with an example and then follow up with reference information.

== Example ==

The example discussed here is available in the distribution under `examples/jcs`. This example is a HTML page that executes a cycle of CRUD operations on a `Person` object. The attributes of the `Person` are first read from a HTML table and the `Person` object is inserted into the database. Then the same person is read back to populate another HTML table. `Person` attributes to update the in the database are read from another table, and finally the `Person` is deleted from the database. The CRUD cycle can be executed in a sequential fashion, or, with asynchronous calls to the server. Here is a screen shot of `jbati-client-side.html` in action:

[http://beavercreekconsulting.com/img/jbati-client-side.html.png]

The top portion of `jbati-client-side.html` shows the pieces that are need:

{{{
001 <html>
002   <head>
003     <title>jBati Examples - jBati Client Side</title>
004
005     <!--
006       -- An example of jBati client side usage
007       -->
008
009     <!-- load jBati server side framework -->
010     <script src="../../lib/jbati-server.js" runat="server" autoload="true"></script>
011
012     <!-- load jBati client side framework -->
013     <script src="../../lib/jbati-client.js"></script>
014
015     <!-- Domain objects, expose on client and server -->
016     <script src="user-objects.js" runat="both" autoload="true"></script>
017
018     <!-- Domain objects ORM mapping, needed only on server -->
019     <script src="user-object-maps.js" runat="server" autoload="true"></script>
}}}

On line 10, the server side of the jBati framework is imported into the server execution context. The Jaxer attributes are important here; both `runat="server"` and `autoload="true"` are necessary. Likewise, the client side of the jBati framework, which runs in the browser, is loaded on line 13.

You'll need to supply equivalent scripts for the next two included script. The first script script defines domain objects and the second script tells jBati to load your configuration files which contains SQL and the mapping to objects.

The domain objects need to be available on the client, where you'll use them, and on the server side, where jBati will take care of persistence operations. On line 16, the domain objects are imported into both the client and server context with the script attributes of `runat="both"` and `autoload="true"`. Here's a listing of `user-objects.js`:

{{{
001 //
002 // User domain objects
003 //
004 (function () {
005
006     if(typeof Examples == 'undefined') {
007             Examples = {};
008     }
009
010     Examples.Domain = {};
011     Examples.Domain.Person = function () {};
012
013
014 })();
}}}

`Person` is a pretty lightweight domain object. In fact, if you find yourself declaring this type of object, you can just use the !JavaScript `Object` class in your object mapping. In any case, here, the domain objects are kept in a namespace object (`Examples`). Executing this code is need during server callbacks to populate the global variable `Examples` and thus the script attribute `autoload="true"` is required for this example. On the other hand, if you're not using a namespace, the autoload attribute is not needed.

The next bit of scripting you need to provide tells jBati to load your SQL and object mapping files. On line 19 `user-object-maps.js` is loaded. Here's a listing:

{{{
001 //
002 // Load the SqlMapConfig file
003 //
004 (function () {
005
006     var path = Jaxer.Dir.resolvePath('../jcs/sqlMapConfig.xml');
007     var url = Jaxer.Dir.pathToUrl(path);
008     JBati.Server.SqlMapClientBuilder.buildSqlMapClient(url, 'ExamplesJSS');
009
010 })();
}}}

Loading the object mapping configuration is a server side only operation as you likely don't want to expose this information on the Internet. Therefore, the including script tag is `run="server"`. The path to the file on line 6 is a file system path, relative in this case, which gets resolved to a file protocol URL on line 7. Line 8 invokes the jBati call to parse the configuration file and build a jBati client.

In this example, the jBati client is used on the browser side. The second parameter to `buildSqlMapClient()`, `'!ExampleJSS'`, names the client for later retrieval by !JavaScript executing in the browser. Naming the client is optional and needed only if you're using multiple database connections. The unnamed, or default, client uses the Jaxer application database connection.

The next item needed is the jBati configuration files. The first file, `sqlMapConfig.xml`, contains a sqlMapConfig document:

{{{
001 <?xml version="1.0" encoding="UTF-8" ?>
002 <!DOCTYPE sqlMapConfig
003     PUBLIC "-//ibatis.apache.org//DTD SQL Map Config 2.0//EN"
004     "http://ibatis.apache.org/dtd/sql-map-config-2.dtd">
005
006 <sqlMapConfig>
007     <sqlMap resource="person.xml"/>
008 </sqlMapConfig>
}}}

This file is pretty light weight in the current version. The only interesting part is loading a sqlMap XML file named `person.xml`. The resource attribute is a path relative to the sqlMapConfig file. In future releases, this file will contain configuration specific to a database connection (such as database type, !SqlLite or !MySql, and connection credentials). A real application would include several sqlMap files, with files split per domain object for easier maintenance.

Finally, `person.xml` holds the SQL and object mapping:

{{{
001 <?xml version="1.0" encoding="UTF-8" ?>
002 <!DOCTYPE sqlMap
003     PUBLIC "-//ibatis.apache.org//DTD SQL Map 2.0//EN"
004     "http://ibatis.apache.org/dtd/sql-map-2.dtd">
005
006 <sqlMap>
007
008     <!-- Use scalar type as parameter and allow results to
009     be auto-mapped results to Person object -->
010     <select id="getPerson" resultClass="Examples.Domain.Person">
011             SELECT
012             PER_ID                  as id,
013             PER_FIRST_NAME  as firstName,
014             PER_LAST_NAME   as lastName,
015             PER_BIRTH_DATE  as birthDate,
016             PER_WEIGHT_KG   as weightInKilograms,
017             PER_HEIGHT_M            as heightInMeters
018             FROM person
019             WHERE PER_ID = #value#
020     </select>
021
022     <!-- Use Person object properties as parameters for insert.  Each of the
023     parameters in the #hash# symbols is a Person property.  -->
024     <insert id="insertPerson">
025             INSERT INTO person (
026                     PER_ID, PER_FIRST_NAME, PER_LAST_NAME,
027                     PER_BIRTH_DATE, PER_WEIGHT_KG, PER_HEIGHT_M
028             ) VALUES (
029                     #id#, #firstName#, #lastName#,
030                     #birthDate#, #weightInKilograms#, #heightInMeters#
031             )
032     </insert>
033
034     <!-- Use Person object properties as parameters for update. Each of the
035     parameters in the #hash# symbols is a Person property.  -->
036     <update id="updatePerson">
037             UPDATE person
038             SET PER_FIRST_NAME = #firstName#,
039             PER_LAST_NAME = #lastName#,
040             PER_BIRTH_DATE = #birthDate#,
041             PER_WEIGHT_KG = #weightInKilograms#,
042             PER_HEIGHT_M = #heightInMeters#
043             WHERE PER_ID = #id#
044     </update>
045
046     <!-- Use Person object "id" properties as parameters for delete. Each of the
047     parameters in the #hash# symbols is a Object property.  -->
048     <delete id="deletePerson">
049             DELETE FROM person
050             WHERE PER_ID = #id#
051     </delete>
052
053 </sqlMap>
}}}

This file is a pretty direct copy from the iBATIS tutorials. This is noted here, not just to give the due credit, but to also point out a fundamental design decision. The jBati configuration documents conform to the iBATIS DTD. There are many elements that are not in fact supported by jBati. However, the aim is to allow validation of the XML and support similar semantics.

All of the elements are in place, so let's look at some code to see how the sqlMap is used. The select statement on lines 8-20 is executed with the following code. First, a jBati client is fetched:

{{{
        var client = new Jbati.Client.SqlMapClient('ExamplesJSS');
}}}

Then, a single `Person` object is fetched:

{{{
        var p = client.queryForObject('getPerson', 1);
}}}

The parameter `'getPerson'` is the id attribute of the XML select element and is used to identify which SQL statement is to be executed. The SQL has replacement tokens such as the `#id#` parameter on line 19 of the sqlMap document. The replacement token is typical substituted with similarly named property of the passed in parameter object. In this case, since the parameter is a single valued, or scalar, parameter, jBati uses it irregardless of the name of the replacement token.

The select statement is executed and jBati then creates a new instance of `Person` and populates properties of the `Person` object with the result set. The SQL statement has column aliases for the columns. This allows mapping of table columns to object properties.

Executing the insert statement shows how to use a object as the parameter object. For example, if we have a `Person` object:

{{{
var p = new Examples.domain.Person();
p.id: 1001,
p.firstName = 'Bob',
p.lastName ='Jones',
p.birthDate = new Date(1975, 2, 13),
p.weightInKilograms = 82.45,
p.heightInMeters = 1.88
}}}

This object can be used to fill in the values for the `updatePerson` SQL statement:

{{{
client.update('updatePerson', p);
}}}

This wraps up the first example.

It is worth noting that jBati supports one other main usage pattern, which is jBati on the server side. In this pattern, you would write server side code that interacts with jBati, and then also write a server side data access API with methods marked for Jaxer to proxy. For an example of this pattern, see examples/jss.

The next sections document the sqlMapConfig and sqlMap XML documents.

== !SqlMapConfig ==

The sqlMapConfig element is loaded with the call:

{{{
Jbati.Server.SqlMapClientBuilder.buildSqlMapClient(url).
}}}

The argument url must be a file protocol URL.

The sqlMapConfig XML document should conform to the iBATIS sqlMapConfig DTD (http://ibatis.apache.org/dtd/sql-map-config-2.dtd). Many elements in the DTD are not supported and will be ignored. The supported elements are listed in the following table:

|| *Element* || *Attribute* || *Description* ||
|| sqlMapConfig ||  ||  ||
|| !SqlMap || resource || File system path to a sqlMap file. Relative paths are relative to the location of the sqlMapConfig file. ||

== !SqlMap ==

Similar to the sqlMapConfig document, the sqlMap XML document should conform to the iBATIS sqlMap DTD (http://ibatis.apache.org/dtd/sql-map-2.dtd).

Many elements in the DTD are not supported and will be ignored. The supported elements and attributes are listed in the following table:

|| *Element* || *Attribute* || *Description* ||
|| sqlMap ||  ||  ||
|| select ||  || Contains a SQL select statement as CDATA. ||
|| select || id || The is by which SQL statements are referred to. All API calls that execute DML require this as a parameter. ||
|| select || resultClass || The class from which an object instances will be created and populated with the result set values. ||
|| update ||  || Contains a SQL update statement as CDATA. ||
|| update || id || The is by which SQL statements are referred to. All API calls that execute DML require this as a parameter. ||
|| insert ||  || Contains a SQL insert statement as CDATA. ||
|| insert || id || The is by which SQL statements are referred to. All API calls that execute DML require this as a parameter. ||
|| delete ||  || Contains a SQL delete statement as CDATA. ||
|| delete || id || The is by which SQL statements are referred to. All API calls that execute DML require this as a parameter. ||