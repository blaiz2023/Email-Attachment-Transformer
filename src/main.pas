unit main;

interface
{$ifdef gui3} {$define gui2} {$define net} {$define ipsec} {$endif}
{$ifdef gui2} {$define gui}  {$define jpeg} {$endif}
{$ifdef gui} {$define bmp} {$define ico} {$define gif} {$define snd} {$endif}
{$ifdef con3} {$define con2} {$define net} {$define ipsec} {$endif}
{$ifdef con2} {$define bmp} {$define ico} {$define gif} {$define jpeg} {$endif}
{$ifdef fpc} {$mode delphi}{$define laz} {$define d3laz} {$undef d3} {$else} {$define d3} {$define d3laz} {$undef laz} {$endif}
uses gossroot, {$ifdef gui}gossgui,{$endif} {$ifdef snd}gosssnd,{$endif} gosswin, gossio, gossimg, gossnet;
{$B-} {generate short-circuit boolean evaluation code -> stop evaluating logic as soon as value is known}
//## ==========================================================================================================================================================================================================================
//##
//## MIT License
//##
//## Copyright 2025 Blaiz Enterprises ( http://www.blaizenterprises.com )
//##
//## Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
//## files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
//## modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software
//## is furnished to do so, subject to the following conditions:
//##
//## The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//##
//## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//## OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//## LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//## CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//##
//## ==========================================================================================================================================================================================================================
//## Library.................. app code (main.pas)
//## Version.................. 2.00.815 (+10)
//## Items.................... 1
//## Last Updated ............ 27nov2025, 17jun2025, 13apr2025
//## Lines of Code............ 1,700+
//##
//## main.pas ................ app code
//## gossroot.pas ............ console/gui app startup and control
//## gossio.pas .............. file io
//## gossimg.pas ............. image/graphics
//## gossnet.pas ............. network
//## gosswin.pas ............. 32bit windows api's
//## gosssnd.pas ............. sound/audio/midi/chimes
//## gossgui.pas ............. gui management/controls
//## gossdat.pas ............. static data/icons/splash/help settings/help document(gui only)
//##
//## ==========================================================================================================================================================================================================================
//## | Name                   | Hierarchy         | Version   | Date        | Update history / brief description of function
//## |------------------------|-------------------|-----------|-------------|--------------------------------------------------------
//## | tapp                   | tbasicapp         | 2.00.805  | 27nov2025   | Email Attachment Transformer - 13apr2025
//## ==========================================================================================================================================================================================================================
//## Performance Note:
//##
//## The runtime compiler options "Range Checking" and "Overflow Checking", when enabled under Delphi 3
//## (Project > Options > Complier > Runtime Errors) slow down graphics calculations by about 50%,
//## causing ~2x more CPU to be consumed.  For optimal performance, these options should be disabled
//## when compiling.
//## ==========================================================================================================================================================================================================================


var
   itimerbusy:boolean=false;
   iapp:tobject=nil;


type
//xxxxxxxxxxxxxxxxxxxxxxx//1111111111111111111
{tapp}
   tapp=class(tbasicapp)
   private

    itimerfast,itimer500:comp;
    iloaded,ibuildingcontrol:boolean;
    isettingsref,icolor,ilastsavefile,ilastopenfile,ilastopenfolder:string;
    ipopshowDelay,ilastopenfilterindex:longint;
    iscreen:tbasiccontrol;
    iv:tbasicscrollbar;
    iimage,itemp:trawimage;
    itempfiledata:tstr8;
    idownvpos,ifilecount,isizelimit,ilastpos:longint;
    idellist,ipacklist:tdynamicstring;

    procedure xcmd(sender:tobject;xcode:longint;xcode2:string);
    procedure __onclick(sender:tobject);
    procedure __ontimer(sender:tobject); override;
    procedure xshowmenuFill1(sender:tobject;xstyle:string;xmenudata:tstr8;var ximagealign:longint;var xmenuname:string);
    function xshowmenuClick1(sender:tbasiccontrol;xstyle:string;xcode:longint;xcode2:string;xtepcolor:longint):boolean;
    procedure xloadsettings;
    procedure xsavesettings;
    procedure xautosavesettings;
    procedure screen__onalign(sender:tobject);
    procedure screen__onpaint(sender:tobject);
    function screen__onnotify(sender:tobject):boolean;
    function screen__onaccept(sender:tobject;xfolder,xfilename:string;xindex,xcount:longint):boolean;
    procedure status__onclickcell(sender:tobject);
    procedure xsync;
    procedure xupdatebuttons;
    function xsize:longint;
    function xempty:boolean;
    function xcanclear:boolean;
    procedure xclear;
    procedure xpack(xpacklist:tdynamicstring;xsubfolders:boolean);
    function popsaveimg(var xfilename:string;xcommonfolder,xtitle2:string;var daction:string):boolean;//18jun2021, 12apr2021
    function popopenimg(var xfilename:string;var xfilterindex:longint;xcommonfolder:string):boolean;//12apr2021
    procedure xreadfromtemp;
    function xcanunpack:boolean;
    procedure xunpack;
    function s(xcount:longint):string;
    function xholdingfolder:string;
    function xnewfolder:string;
    procedure xloadit_dontpackit;
    procedure setcolor(x:string);
    function xcolorlabel:string;
    procedure xcopybase64(dext:string);//27nov2025

   public

    //create
    constructor create; virtual;
    destructor destroy; override;

    //information
    property color:string read icolor write setcolor;//pack color

   end;

//info procs -------------------------------------------------------------------
function app__info(xname:string):string;
function info__app(xname:string):string;//information specific to this unit of code - 20jul2024: program defaults added, 23jun2024


//app procs --------------------------------------------------------------------
//.create / destroy
procedure app__remove;//does not fire "app__create" or "app__destroy"
procedure app__create;
procedure app__destroy;

//.event handlers
function app__onmessage(m,w,l:longint):longint;
procedure app__onpaintOFF;//called when screen was live and visible but is now not live, and output is back to line by line
procedure app__onpaint(sw,sh:longint);
procedure app__ontimer;

//.support procs
function app__netmore:tnetmore;//optional - return a custom "tnetmore" object for a custom helper object for each network record -> once assigned to a network record, the object remains active and ".clear()" proc is used to reduce memory/clear state info when record is reset/reused
function app__findcustomtep(xindex:longint;var xdata:tlistptr):boolean;
function app__syncandsavesettings:boolean;

function io__isfolder(const x:string):boolean;
function io__saferelative_pathname(const x:string):string;//relative

function eat__unpack(s:trawimage;xfolder:string;xcheckonly:boolean;var xcount,xwriteerrs:longint;var e:string):boolean;
function eat__pack(s:trawimage;xpacklist:tdynamicstring;xcolor,xfolder:string;xsubfolders:boolean;xsizelimit:longint;var xcount:longint;var e:string):boolean;

implementation

{$ifdef gui}
uses
    gossdat;
{$endif}


//info procs -------------------------------------------------------------------
function app__info(xname:string):string;
begin
result:=info__rootfind(xname);
end;

function info__app(xname:string):string;//information specific to this unit of code - 20jul2024: program defaults added, 23jun2024
begin
//defaults
result:='';

try
//init
xname:=strlow(xname);

//get
if      (xname='slogan')              then result:=info__app('name')+' by Blaiz Enterprises'
else if (xname='width')               then result:='1350'
else if (xname='height')              then result:='800'
else if (xname='language')            then result:='english-australia'//for Clyde - 14sep2025
else if (xname='codepage')            then result:='1252'//for Clyde
else if (xname='ver')                 then result:='2.00.815'
else if (xname='date')                then result:='27nov2025'
else if (xname='name')                then result:='Email Attachment Transformer'
else if (xname='web.name')            then result:='eat'//used for website name
else if (xname='des')                 then result:='Pack files into an image for sending via email'
else if (xname='infoline')            then result:=info__app('name')+#32+info__app('des')+' v'+app__info('ver')+' (c) 1997-'+low__yearstr(2025)+' Blaiz Enterprises'
else if (xname='size')                then result:=low__b(io__filesize64(io__exename),true)
else if (xname='diskname')            then result:=io__extractfilename(io__exename)
else if (xname='service.name')        then result:=info__app('name')
else if (xname='service.displayname') then result:=info__app('service.name')
else if (xname='service.description') then result:=info__app('des')
else if (xname='new.instance')        then result:='1'//1=allow new instance, else=only one instance of app permitted
else if (xname='screensizelimit%')    then result:='98'//98% of screen area
else if (xname='realtimehelp')        then result:='0'//1=show realtime help, 0=don't
else if (xname='hint')                then result:='1'//1=show hints, 0=don't

//.links and values
else if (xname='linkname')            then result:=info__app('name')+' by Blaiz Enterprises.lnk'
else if (xname='linkname.vintage')    then result:=info__app('name')+' (Vintage) by Blaiz Enterprises.lnk'
//.author
else if (xname='author.shortname')    then result:='Blaiz'
else if (xname='author.name')         then result:='Blaiz Enterprises'
else if (xname='portal.name')         then result:='Blaiz Enterprises - Portal'
else if (xname='portal.tep')          then result:=intstr32(tepBE20)
//.software
else if (xname='url.software')        then result:='https://www.blaizenterprises.com/'+info__app('web.name')+'.html'
else if (xname='url.software.zip')    then result:='https://www.blaizenterprises.com/'+info__app('web.name')+'.zip'
//.urls
else if (xname='url.portal')          then result:='https://www.blaizenterprises.com'
else if (xname='url.contact')         then result:='https://www.blaizenterprises.com/contact.html'
else if (xname='url.facebook')        then result:='https://web.facebook.com/blaizenterprises'
else if (xname='url.mastodon')        then result:='https://mastodon.social/@BlaizEnterprises'
else if (xname='url.twitter')         then result:='https://twitter.com/blaizenterprise'
else if (xname='url.x')               then result:=info__app('url.twitter')
else if (xname='url.instagram')       then result:='https://www.instagram.com/blaizenterprises'
else if (xname='url.sourceforge')     then result:='https://sourceforge.net/u/blaiz2023/profile/'
else if (xname='url.github')          then result:='https://github.com/blaiz2023'
//.program/splash
else if (xname='license')             then result:='MIT License'
else if (xname='copyright')           then result:='© 1997-'+low__yearstr(2025)+' Blaiz Enterprises'
else if (xname='splash.web')          then result:='Web Portal: '+app__info('url.portal')

else
   begin
   //nil
   end;

except;end;
end;


//app procs --------------------------------------------------------------------
procedure app__create;
begin
{$ifdef gui}
iapp:=tapp.create;
{$else}

//.starting...
app__writeln('');
//app__writeln('Starting server...');

//.visible - true=live stats, false=standard console output
scn__setvisible(false);


{$endif}
end;

procedure app__remove;
begin
try

except;end;
end;

procedure app__destroy;
begin
try
//save
//.save app settings
app__syncandsavesettings;

//free the app
freeobj(@iapp);
except;end;
end;

function app__findcustomtep(xindex:longint;var xdata:tlistptr):boolean;

  procedure m(const x:array of byte);//map array to pointer record
  begin
  {$ifdef gui}
  xdata:=low__maplist(x);
  {$else}
  xdata.count:=0;
  xdata.bytes:=nil;
  {$endif}
  end;
begin//Provide the program with a set of optional custom "tep" images, supports images in the TEA format (binary text image)
//defaults
result:=false;

//sample custom image support

//m(tep_none);
{
case xindex of
5000:m(tep_write32);
5001:m(tep_search32);
end;
}

//successful
//result:=(xdata.count>=1);
end;

function app__syncandsavesettings:boolean;
begin
//defaults
result:=false;
try
//.settings
{
app__ivalset('powerlevel',ipowerlevel);
app__ivalset('ramlimit',iramlimit);
{}


//.save
app__savesettings;

//successful
result:=true;
except;end;
end;

function app__netmore:tnetmore;//optional - return a custom "tnetmore" object for a custom helper object for each network record -> once assigned to a network record, the object remains active and ".clear()" proc is used to reduce memory/clear state info when record is reset/reused
begin
result:=tnetbasic.create;
end;

function app__onmessage(m,w,l:longint):longint;
begin
//defaults
result:=0;
end;

procedure app__onpaintOFF;//called when screen was live and visible but is now not live, and output is back to line by line
begin
//nil
end;

procedure app__onpaint(sw,sh:longint);
begin
//console app only
end;

procedure app__ontimer;
begin
try
//check
if itimerbusy then exit else itimerbusy:=true;//prevent sync errors

//last timer - once only
if app__lasttimer then
   begin

   end;

//check
if not app__running then exit;


//first timer - once only
if app__firsttimer then
   begin

   end;



except;end;
try
itimerbusy:=false;
except;end;
end;

function io__isfolder(const x:string):boolean;
begin
result:=(strcopy1(x,low__len(x),1)='\');
end;

function io__saferelative_pathname(const x:string):string;//relative
var
   v,lv,p:longint;
begin
//defaults
result:=x;
lv    :=0;

//get
for p:=1 to low__len(result) do
begin
v:=byte(result[p-1+stroffset]);

case v of
0..31:v:=ssDash;
ssDot:if (lv=v) then v:=ssdash;
ssSemicolon,ssasterisk,ssQuestion,ssDoublequote,ssLessthan,ssmorethan,ssPipe,ssDollar,ssColon:v:=ssDash;
ssslash:v:=ssBackslash;
end;//case

result[p-1+stroffset]:=char(v);

lv:=v;
end;//p

end;

function eat__unpack(s:trawimage;xfolder:string;xcheckonly:boolean;var xcount,xwriteerrs:longint;var e:string):boolean;
label
   skipend;
const
   bindent       =2;
   bindent3      =bindent*3;
   bheadsize     =4+4+4+1+4;//label.rowcount(4) + data.rowcount(4) + data size(4) + compression state(1) + filename.len(4) + filename.data(0..N)
var
   xline,b:tstr8;
   xbytesperrow,ecount,ypos,dw,dh,fi,bhlimit:longint;
   xpathname:string;

   function xcanpull:boolean;
   begin
   result:=ypos<dh;
   end;

   function xpull(var xpathname:string;xdata:tstr8):boolean;
   label
      redo,skipdone,skipend;
   var
      sr24:pcolorrow24;
      d:pdlbyte;
      xinfo:boolean;
      xcrc32,hlabel,hdata,xdatasize,xnamelen,p:longint;
      xcompressed:boolean;
      etmp:string;
   begin
   //defaults
   result    :=false;
   xpathname :='';

   try
   //check
   if not str__lock(@xdata) then exit;
   if not xcanpull          then goto skipend;

   //init
   str__clear(@xdata);
   xinfo:=true;
   xline.setlen(xbytesperrow);

   //get
   redo:
   if (not xinfo) then
      begin
      dec(hdata);
      if (hdata<0) then goto skipdone;
      end;

   if not misscan24(s,ypos,sr24) then goto skipend;
   d:=@sr24^;

   //scanline RGB -> byte list
   for p:=0 to (xbytesperrow-1) do xline.pbytes[p]:=255-d[bIndent3+p];//invert

   //read label
   if xinfo then
      begin
      //once
      xinfo:=false;

      //get
      hlabel     :=xline.int4[0];
      hdata      :=xline.int4[4];
      xcrc32     :=xline.int4[8];
      xdatasize  :=xline.int4[12];
      xcompressed:=xline.bol1[16];
      xnamelen   :=xline.int4[17];//17..20

      //check
      if (hlabel<1) or (hlabel>100)         or
         (hdata<0) or (hdata>=max32)        or
         (xnamelen<0) or (xnamelen>1024)    or
         (xdatasize<0) or (xdatasize>max32) then
         begin
         inc(ecount);
         inc(ypos);
         goto skipend;
         end;

      //set
      xpathname  :=xline.str[21,xnamelen];
      if (xpathname<>'') then xpathname:=io__saferelative_pathname(xpathname);

      //inc
      inc(ypos,hlabel);
      goto redo;
      end;

   //read data
   xdata.add(xline);

   //inc
   inc(ypos);
   if (ypos<dh) then goto redo;

   //trim to size
   skipdone:
   if (xdata.len>xdatasize) then xdata.setlen(xdatasize);

   //check
   if (xcrc32<>low__crc32b(xdata)) then
      begin
      inc(ecount);
      goto skipend;
      end;

   //decompress
   if (not xcheckonly) and (xdata.len>=1) and xcompressed then low__decompress(@xdata);

   //write file
   if (not xcheckonly) and (xfolder<>'') and (xpathname<>'') and (not io__tofile(xfolder+xpathname,@xdata,etmp)) then inc(xwriteerrs);

   //successful
   result:=true;
   skipend:
   except;end;
   //clear on error
   if not result then str__clear(@xdata);
   //free
   str__uaf(@xdata);
   end;
begin
//defaults
result :=false;
e      :=gecTaskfailed;
xline  :=nil;
b      :=nil;
ypos   :=0;
xcount :=0;
xwriteerrs:=0;
ecount :=0;

//check
if not misok24(s,dw,dh) then exit;

try
//init
xline        :=str__new8;
b            :=str__new8;
xbytesperrow :=(dw*3)-(2*bindent3);

if (xbytesperrow<=bheadsize) then
   begin
   e:=gecDatacorrupt;
   goto skipend;
   end;

//get
while xcanpull do
begin

if xpull(xpathname,b) then
   begin
   if (xpathname<>'') then inc(xcount);
   end
else if (ecount>=100) then break;//too many errors

//.write file
if (not xcheckonly) and (xpathname<>'') then
   begin

   end;

end;//loop

//error
if (xcount<=0) then
   begin
   e:='No files found';
   goto skipend;
   end
else if (ecount>=1) then
   begin
   e:='Some files are damaged';
   goto skipend;
   end;

//successful
result:=true;
skipend:
except;end;
//free
str__free(@xline);
str__free(@b);
end;

function eat__pack(s:trawimage;xpacklist:tdynamicstring;xcolor,xfolder:string;xsubfolders:boolean;xsizelimit:longint;var xcount:longint;var e:string):boolean;
label
   skipend,skipend2;
const
   bindent       =2;
   bindent3      =bindent*3;
   bw            =1024;
   bbytesperrow0 =bw*3;//3072
   bbytesperrow  =bbytesperrow0 - (2*bindent3);//3060
   bheadsize     =4+4+4+4+1+4;//label.rowcount(4) + data.rowcount(4) + data.crc32(4) + data size(4) + compression state(1) + filename.len(4) + filename.data(0..N)
   bhlabel       =15;//14 rows for a display label
var
   xline,b,c:tstr8;
   xback2,xback,xtext,dfolderlen,int1,int2,fi,bhlimit,p2,p:longint;
   flist:tdynamicstring;
   plOK,xonce:boolean;
   str1,dfolder,dname:string;

   function xpush(xdata:tstr8;xorgsize,xbackcolor,xbackcolor2,xtextcolor:longint;xcompressed,xaslabel,xoverridelimit:boolean;xpathname:string):boolean;
   label
      skipend;
   var
      ta,da:twinrect;
      dy,p,xdatapos,sy,sx,yfrom,dw,dh,hcount:longint;
      sr24:pcolorrow24;
      d:pdlbyte;
      c:tcolor24;
   begin
   //defaults
   result:=false;

   try
   //init
   dw     :=misw(s);
   dh     :=mish(s);
   hcount :=(xdata.len div bbytesperrow);
   if ((hcount*bbytesperrow)<xdata.len) then inc(hcount);

   if xonce then
      begin
      xonce:=false;
      yfrom:=0;
      end
   else yfrom:=mish(s);

   //check -> too big
   if (not xoverridelimit) and ((yfrom+hcount+bhlabel)>bhlimit) then goto skipend;

   //size
   if not missize(s,bw,yfrom+hcount+bhlabel) then goto skipend;

   //label
   da        :=area__make(bIndent,yfrom,bw-1-bIndent,yfrom+bhlabel-1);

   case (xbackcolor<>xbackcolor2) of
   true:begin
      ta        :=da;
      ta.left   :=0;
      ta.right  :=bw-1;
      ta.bottom :=da.top + ((da.bottom-da.top+1) div 2);

      if not misclsarea2(s,ta,xbackcolor2,xbackcolor) then goto skipend;

      ta.top    :=ta.bottom;
      ta.bottom :=da.bottom;
      if not misclsarea2(s,ta,xbackcolor,xbackcolor2) then goto skipend;
      end;
   else if not misclsarea(s,da,xbackcolor) then goto skipend;
   end;//case

   case xaslabel of
   true:xline.text:=xpathname;
   else
      begin
      xpathname:=io__saferelative_pathname(xpathname);//filter
      xline.text:='['+k64(1+xcount)+'] '+xpathname+' ('+k64(xorgsize)+' b)';
      end;
   end;

   fi        :=low__font0('Courier New',8);
   dy        :=frcmin32(da.top+((bhlabel-low__fontmaxh(fi)) div 2),da.top);
   low__draw2b(clnone,false,tbNone,misb(s),misw(s),mish(s),s.rows,nil,nil,bIndent,'t',da,da,da,xtextcolor,xtextcolor,clnone,da.left+10,dy,viFeather,0,0,0,0,sysfont_data[fi],xline,corNone,false,false,false,false,false);

   //.1st line of label: bheadsize + filename.data
   if not misscan24(s,yfrom,sr24) then goto skipend;
   d:=@sr24^;
   xline.clear;
   xline.addint4(bhlabel);
   xline.addint4(hcount);
   xline.addint4(low__crc32b(xdata));
   xline.addint4(xdata.len);
   xline.addbol1(xcompressed);
   if xaslabel then xline.addint4(0)
   else
      begin
      xline.addint4(low__len(xpathname));
      xline.sadd(xpathname);
      end;

   for p:=0 to frcmax32(xline.len-1,bbytesperrow-1) do d[bindent3+p]:=255-xline.bytes[p];//invert data
   xline.clear;

   //.inc
   inc(yfrom,bhlabel);

   //data
   xdatapos:=0;

   for sy:=yfrom to (yfrom+hcount-1) do
   begin
   if not misscan24(s,sy,sr24) then goto skipend;
   d:=@sr24^;

   for p:=0 to (bbytesperrow-1) do
   begin
   d[bindent3+p]:=255-xdata.bytes[xdatapos];//invert data
   inc(xdatapos);
   end;//p

   end;//sy

   //successful
   result:=true;
   skipend:
   except;end;
   end;

   function xadd(const xfilename:string;xpathname:string;var e:string):boolean;
   label
      skipend;
   var
      etmp:string;
      bc,tc:longint;
   begin
   //defaults
   result    :=false;
   xpathname :=strcopy1(xpathname,1,bbytesperrow-bheadsize);

   try
   //load file
   if not io__fromfile(xfilename,@b,etmp) then
      begin
      e:=etmp;
      goto skipend;
      end;

   //compress
   str__clear(@c);
   str__add(@c,@b);
   if not low__compress(@c) then
      begin
      e:=gecTaskfailed;
      goto skipend;
      end;

   //colors
   if low__iseven(xcount) then
      begin
      bc:=rgba0__int(10,10,10);
      tc:=rgba0__int(190,190,190);
      end
   else
      begin
      bc:=rgba0__int(30,30,30);
      tc:=rgba0__int(190,190,190);
      end;

   //decide
   if (c.len<b.len) then
      begin
      if not xpush(c,b.len,bc,bc,tc,true,false,false,xpathname) then
         begin
         e:='At capacity.  Not all files included.';
         goto skipend;
         end;
      end
   else
      begin
      if not xpush(b,b.len,bc,bc,tc,false,false,false,xpathname) then
         begin
         e:='At capacity.  Not all files included.';
         goto skipend;
         end;
      end;

   //successful
   result:=true;
   skipend:
   except;end;
   end;

begin
//defaults
result :=false;
e      :=gecTaskfailed;
b      :=nil;
c      :=nil;
flist  :=nil;
xline  :=nil;
xcount :=0;
xonce  :=true;

if not misok24(s,int1,int2) then exit;

try
//range
xsizelimit :=frcrange32(xsizelimit,100000,300*1000*1024);//100K to 300Mb
bhlimit    :=xsizelimit div bbytesperrow0;

//init
flist :=tdynamicstring.create;
b     :=str__new8;
c     :=str__new8;
xline :=str__new8;
plok  :=(xpacklist<>nil) and (xpacklist.count>=1);
xcolor:=strlow(xcolor);

//.by color name
if      (xcolor='r') then xback :=rgba0__int(255,95,95)
else if (xcolor='y') then xback :=rgba0__int(240,240,20)
else if (xcolor='g') then xback :=rgba0__int(20,240,20)
else if (xcolor='b') then xback :=rgba0__int(70,165,250)
else if (xcolor='p') then xback :=rgba0__int(165,140,250)//purple
else if (xcolor='x') then xback :=rgba0__int(240,140,190)//pink
else if (xcolor='w') then xback :=rgba0__int(240,240,240)
else                      xback :=rgba0__int(20,200,210);

//.other colors
xback2:=int__dif24(xback,-40);
xtext :=rgba0__int(60,60,60);


//filelist
if (not plok) then
   begin
   if not io__filelist1(flist,false,xsubfolders,xfolder,'*','') then goto skipend2;
   end;

//clear
missize(s,1,1);

//eat label
str__clear(@b);
xpush(b,b.len,xback,xback2,xtext,false,true,false,app__info('name')+' v'+app__info('ver')+': Packed files appear below. To avoid data corruption store/send this image as a BMP, PNG, TGA, or PPM.');

//get
case plok of
true:begin
   //expand sub-folders and include their files to the packlist
   for p:=(xpacklist.count-1) downto 0 do if io__isfolder(xpacklist.value[p]) then
      begin
      flist.clear;
      io__filelist1(flist,true,true,xpacklist.value[p],'*','');
      for p2:=0 to (flist.count-1) do xpacklist.value[xpacklist.count]:=flist.value[p2];
      end;

   //find common root folder
   dfolder:='';
   for p:=0 to (xpacklist.count-1) do
   begin
   str1:=io__asfolderNIL(io__extractfilepath(xpacklist.value[p]));
   if (str1<>'') then
      begin
      if (dfolder='') then dfolder:=str1;

      //step down to short folder name
      if not strmatch(dfolder,str1) then
         begin

         for p2:=(low__len(str1)-1) downto 1 do if (str1[p2-1+stroffset]='\') then
            begin
            dfolder:=strcopy1(str1,1,p2);
            break;
            end;

         end;
      end;
   end;//p

   dfolderlen:=low__len(dfolder);

   //pack the packlist
   for p:=0 to (xpacklist.count-1) do if not io__isfolder(xpacklist.value[p]) then
      begin
      //.filename in root folder OR use name part only (no path)
      dname:=xpacklist.value[p];
      if strmatch(dfolder,strcopy1(dname,1,dfolderlen)) then dname:=strcopy1(dname,dfolderlen+1,low__len(dname)) else dname:=io__extractfilename(dname);

      //.add
      if xadd(xpacklist.value[p],dname,e) then inc(xcount) else goto skipend;
      end;//p

   end
else for p:=0 to (flist.count-1) do if xadd(xfolder+flist.value[p],flist.value[p],e) then inc(xcount) else goto skipend;
end;//case


//successful
result:=true;
skipend:

//eat label
str__clear(@b);
xpush(b,b.len,xback,xback2,xtext,false,true,true,'End of files');

//left and right columns
misclsarea(s,area__make(0,bhlabel,1,mish(s)-1-bhlabel),xback2);
misclsarea(s,area__make(misw(s)-2,bhlabel,misw(s)-1,mish(s)-1-bhlabel),xback2);

skipend2:
except;end;
//free
freeobj(@flist);
str__free(@b);
str__free(@c);
str__free(@xline);
end;



//## tapp ######################################################################
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxx//1111111111111111111111111111111111111
constructor tapp.create;
begin
if system_debug then dbstatus(38,'Debug 010 - 21may2021_528am');//yyyy


//check source code for know problems ------------------------------------------
//io__sourecode_checkall(['']);


//self
inherited create(strint32(app__info('width')),strint32(app__info('height')),true);

ibuildingcontrol     :=true;

//init
itimer500            :=ms64;
itimerfast           :=ms64;

//vars
iloaded              :=false;
ipopshowDelay        :=2;//2 seconds - 27nov2025
ilastpos             :=0;
ifilecount           :=0;
idownvpos            :=0;

ilastopenfolder      :='';
ilastsavefile        :='untitled.bmp';
ilastopenfile        :='';
ilastopenfilterindex :=0;

iimage               :=misraw24(1,1);
itemp                :=misraw24(1,1);
isizelimit           :=50*1000*1000;
ipacklist            :=tdynamicstring.create;
idellist             :=tdynamicstring.create;
itempfiledata        :=str__new8;
icolor               :='';
isettingsref         :='';

//controls
with rootwin do
begin

scroll               :=false;
xhead;
xgrad;
xgrad2;

//.status cells
xstatus2.cellwidth[0]:=190;

xstatus2.cellwidth[1]:=120;

xstatus2.cellwidth[2]:=110;
xstatus2.cellhelp [2]:='Color | Click to set color for header and footer | Color change takes effect on next pack';

xstatus2.cellwidth[3]:=100;
xstatus2.celltext[3] :=#32+'Pack files inside an image for transmission as an email attachment';
xstatus2.cellalign[3]:=0;

//.screen
iscreen:=ncontrol;
iscreen.oautoheight:=true;

//.v
iv:=iscreen.nscrollbar('Click and drag to scroll',true);
iv.overtical:=true;
iv.setparams2(0,0,0,false);
iv.owheelchange:=10;
iv.oassistedscroll:=10*iv.owheelchange;
end;

with rootwin do
begin
xhead.add('New',tepNew20,0,'new','New | Clear contents and start afresh');
xhead.add('Pack',tepFolder20,0,'pack.folder','Pack | Pack folder files into an image');
xhead.add('Pack (S)',tepFolder20,0,'pack.folder+subfolders','Pack | Pack folder files and sub-folders into an image');
xhead.add('Save As',tepSave20,0,'save','Save | Save image with packed files to disk');
xhead.add('Copy',tepCopy20,0,'copy','Copy | Copy image with packed files to Clipboard');
xhead.add('PNG',tepCopy20,0,'copy.b64.png','Copy Image|Copy image to Clipboard as base64 encoded text in mime/type format PNG. Image data can be inserted into HTML code, or viewed by pasting it into your browser''s address bar.');//27nov2025
xhead.addsep;

xhead.add('Paste',tepPaste20,0,'paste','Paste | Paste image with packed files from Clipboard');
xhead.add('Open',tepOpen20,0,'open','Open | Open image with packed files from disk');
xhead.add('Unpack',tepNewFolder20,0,'unpack','Unpack | Unpack files from image to a temporary folder for access');

xhead.addsep;
xhead.xaddoptions;
xhead.xaddhelp;
end;


//default page to show
rootwin.xhead.parentpage       :='overview';

//events
rootwin.xhead.onclick          :=__onclick;
rootwin.xhead.showmenuFill1    :=xshowmenuFill1;
rootwin.xhead.showmenuClick1   :=xshowmenuClick1;
rootwin.xhead.ocanshowmenu     :=true;//use toolbar for special menu display - 18dec2021

iscreen.onalign                :=screen__onalign;
iscreen.onpaint                :=screen__onpaint;
iscreen.onnotify               :=screen__onnotify;
iscreen.onaccept               :=screen__onaccept;
rootwin.xstatus2.clickcell     :=status__onclickcell;

//load settings
ibuildingcontrol               :=false;
xloadsettings;
xsync;

//finish -> start timer etc
createfinish;

end;

destructor tapp.destroy;
begin
try

//settings
xautosavesettings;

//vars
freeobj(@iimage);
freeobj(@itemp);
freeobj(@ipacklist);
freeobj(@idellist);
str__free(@itempfiledata);

//self
inherited destroy;

except;end;
end;

function tapp.xholdingfolder:string;
begin
result:=app__subfolder('temp');
end;

function tapp.xnewfolder:string;
begin
result:=io__asfolder(xholdingfolder+guid__short_date(date__now,true));
io__makefolder(result);
end;

procedure tapp.status__onclickcell(sender:tobject);
var
   i:longint;
begin
if (sender is tbasicstatus) then i:=(sender as tbasicstatus).clickindex else i:=0;


if (i=2) then
   begin
   rootwin.xhead.showmenu2('color');
   end;
end;

function tapp.screen__onaccept(sender:tobject;xfolder,xfilename:string;xindex,xcount:longint):boolean;
var
   df,e:string;
begin
result:=true;

//take a copy of the file if it's from the temp folder -> some temp files don't last long enough to access later on
if strmatch(io__asfolder(io__extractfilepath(xfilename)),io__wintemp) then
   begin
   df:=app__subfolder('temp')+io__extractfilename(xfilename);
   if io__fromfile(xfilename,@itempfiledata,e) and io__tofile(df,@itempfiledata,e) then
      begin
      xfilename:=df;
      idellist.value[idellist.count]:=io__extractfilename(xfilename);//name portion only - 12apr2025
      end;
   str__clear(@itempfiledata);
   end;

ipacklist.value[ipacklist.count]:=xfilename;
end;

procedure tapp.screen__onalign(sender:tobject);
var
   ci:twinrect;
   vwidth:longint;
begin
//v
vwidth:=iv.getalignwidth(0);
ci:=iscreen.clientinner;
iv.xsetclientarea(area__make(ci.right-vwidth-1,ci.top,ci.right,ci.bottom));
end;

procedure tapp.screen__onpaint(sender:tobject);
var
   //infovars
   a:tclientinfo;
   xenabled:boolean;

   //vars
   dsize,fn2,fnH2,tw,dx,dw:longint;
   xcap:string;

begin
try

//init
dsize:=xsize;
iscreen.infovars(a);

//cls
iscreen.lds(area__make(a.cs.left,a.cs.top,iv.left-1,a.cs.bottom),int__splice24(0.2,rgba__int(60,60,60,0),a.back),a.r);
iscreen.lds(area__make(iv.left,a.cs.top,a.cs.right,a.cs.bottom),a.back,a.r);

//text
if (dsize<=0) then
   begin
   fn2:=low__font1(viFontname,round(viFontsize*1.5*vizoom),false);
   fnH2:=low__fontmaxh(fn2);

   xcap:='(( Drop files here to pack ))';
   tw:=low__fonttextwidth2(fn2,xcap);
   iscreen.ldt(a.ci,a.ci.left+((a.ci.right-a.ci.left+1-tw) div 2),a.ci.top+((a.ci.bottom-a.ci.top+1-fnH2) div 2),int__splice24(0.2,rgba0__int(200,200,200),a.font),xcap,fn2,a.f,false);
   end;

//image
dw:=frcmax32(misw(iimage)*a.zoom,iv.left-1);
dx:=frcmin32((iv.left-1-dw) div 2,0);

//draw
if (dsize>=1) then iscreen.ldc(a.ci,a.ci.left+dx,a.ci.top-ilastpos,dw,mish(iimage)*a.zoom,area__make(0,0,(dw div a.zoom)-1,mish(iimage)-1),iimage,255,0,clnone,0);

except;end;
end;

function tapp.screen__onnotify(sender:tobject):boolean;
begin
//defaults
result:=false;

//wheel
if (gui.wheel<>0) then
   begin
   iv._onnotify(nil);
   end;

if gui.mousedownstroke then
   begin
   idownvpos:=iv.pos;
   end;

if gui.mousedown and gui.mousemoved then
   begin
   iv.pos:=idownvpos+(gui.mousedownxy.y-gui.mousemovexy.y);
   end;

end;

function tapp.popsaveimg(var xfilename:string;xcommonfolder,xtitle2:string;var daction:string):boolean;//18jun2021, 12apr2021
var
   xfilterindex:longint;
   xfilterlist:string;
begin
result:=false;

try
//filterlist
xfilterindex:=0;
xfilterlist:=
pebmp+
pepng+
petga+
peppm+
pepnm+
petea+
peimg32+
'';

//get
daction:=ia_tga_24bpp;
daction:=ia__add(daction,ia_tga_RLE);

ia__useroptions_suppress(true,'');//suppress save image format options
result:=gui.xpopnav3(xfilename,xfilterindex,xfilterlist,strdefb(xcommonfolder,low__platimages),'save','','Save Image'+xtitle2,daction,true);
ia__useroptions_suppress_clear;
except;end;
end;

function tapp.popopenimg(var xfilename:string;var xfilterindex:longint;xcommonfolder:string):boolean;//12apr2021
var
   daction,xfilterlist:string;
begin
result:=false;
daction:='';

try
//filterlist
xfilterlist:=
pelosslessimgs+
pebmp+
pepng+
petga+//18mar2025
peppm+
pepnm+
petea+
peimg32;

//get
result:=gui.xpopnav3(xfilename,xfilterindex,xfilterlist,strdefb(xcommonfolder,low__platimages),'open','','Open Image',daction,true);
except;end;
end;

function tapp.s(xcount:longint):string;
begin
result:=insstr('s',xcount<>1);
end;

procedure tapp.xreadfromtemp;
var
   m,e:string;
   xwriteerrs,xcount:longint;
   xok:boolean;
begin
try

xok:=eat__unpack(itemp,'',true,xcount,xwriteerrs,e);

if (xcount<=0) then m:='No files found.'
else                m:=k64(xcount)+' file'+s(xcount)+' found.'+insstr('  Some are damaged.',not xok);


if (xcount>=1) then
   begin
   miscopy(itemp,iimage);
   ifilecount:=xcount;
   ilastpos:=0;
   xsync;
   end;

gui.popstatus(m,ipopshowDelay);

except;end;

//clear
missize(itemp,1,1);

end;

function tapp.xcanclear:boolean;
begin
result:=not xempty;
end;

procedure tapp.xclear;
begin

missize(iimage,1,1);
ifilecount  :=0;
ilastpos    :=0;
xsync;

end;

function tapp.xcanunpack:boolean;
begin
result:=(xsize>=1) and (ifilecount>=1);
end;

procedure tapp.xunpack;
var
   dfolder,m,e:string;
   xwriteerrs,xcount:longint;
   xok:boolean;
begin
try

//check
if not xcanunpack then exit;

//get
dfolder:=xnewfolder;

xok:=eat__unpack(iimage,dfolder,false,xcount,xwriteerrs,e);

if (xcount<=0) then m:='No files found.'
else                m:=k64(xcount)+' file'+s(xcount)+' unpacked.' +insstr('  Some were damaged and were not.',not xok) +insstr('  '+k64(xwriteerrs)+' write error'+s(xwriteerrs)+'.',xwriteerrs>=1);

if (xcount<=0) then io__deletefolder(dfolder) else runLOW(dfolder,'');

gui.popstatus(m,ipopshowDelay);

except;end;
end;

procedure tapp.setcolor(x:string);
begin

x:=strlow(x);
if (x<>'r') and (x<>'y') and (x<>'g') and (x<>'b') and (x<>'p') and (x<>'x') and (x<>'w') then x:='';
icolor:=x;
xsync;

end;

function tapp.xcolorlabel:string;

   procedure m(const n,x:string);
   begin
   if strmatch(n,icolor) then result:=x;
   end;

begin

m('r','Red');
m('y','Yellow');
m('g','Green');
m('b','Blue');
m('p','Purple');
m('x','Pink');
m('w','White');
m('','Default');

end;

procedure tapp.xpack(xpacklist:tdynamicstring;xsubfolders:boolean);
var
   e:string;
begin

if (xpacklist=nil) and (not app__gui.popfolder2(ilastopenfolder,'*','',true,true)) then exit;

gui.popstatus(low__aorbstr('Packing...','Repacking...',(xsize>=1)),1);

case eat__pack(iimage,xpacklist,icolor,ilastopenfolder,xsubfolders,isizelimit,ifilecount,e) of
true:gui.popstatus(k64(ifilecount)+' file'+s(ifilecount)+' packed',2)
else gui.popstatus(e,4);
end;//case

ilastpos:=0;
xsync;
iscreen.paintnow;

//clear
str__clear(@itempfiledata);
itempfiledata.tag1:=0;//not in use

end;

procedure tapp.xcmd(sender:tobject;xcode:longint;xcode2:string);
label
   skipend;
var
   xaction,df,etmp,e:string;
   xcount:longint;

   function xsete(const x:string):boolean;
   begin
   e:=x;
   result:=true;
   end;
begin//use for testing purposes only - 15mar2020
try

//defaults
e:='';

//init
if zzok(sender,7455) and (sender is tbasictoolbar) then
   begin
   //ours next
   xcode:=(sender as tbasictoolbar).ocode;
   xcode2:=strlow((sender as tbasictoolbar).ocode2);
   end;

if (xcode2='pack.folder') or (xcode2='pack.folder+subfolders') then xpack(nil,(xcode2='pack.folder+subfolders'))

else if (xcode2='new') then xclear//27nov2025

else if (xcode2='copy') then
   begin
   if (not xempty) and (not clip__copyimage(iimage)) then e:=gecTaskfailed;
   end

else if (xcode2='copy.b64.png') then//27nov2025
   begin
   if (not xempty) then xcopybase64('png');
   end

else if (xcode2='save') then
   begin
   xaction:='';
   df:=strdefb(ilastsavefile,ilastopenfile);
   if popsaveimg(df,'','',xaction) then
      begin
      ilastsavefile:=df;
      if (not mis__tofile2(iimage,ilastsavefile,io__lastext(ilastsavefile),xaction,etmp)) and xsete(etmp) then goto skipend;
      end;
   end

else if (xcode2='open') then
   begin
   df:=strdefb(ilastopenfile,ilastsavefile);
   if popopenimg(df,ilastopenfilterindex,'') then
      begin
      ilastopenfile:=df;
      if (not mis__fromfile(itemp,ilastopenfile,etmp)) and xsete(etmp) then goto skipend;
      xreadfromtemp;
      end;
   end

else if (xcode2='paste') then
   begin
   if clip__canpasteimage then
      begin
      if (not clip__pasteimage(itemp)) and xsete(gecTaskfailed) then goto skipend;
      xreadfromtemp;
      end;
   end

else if (xcode2='unpack') then xunpack

else if (strcopy1(xcode2,1,9)='setcolor.') then
   begin
   color:=strcopy1(xcode2,10,low__len(xcode2));
   end

else e:='';//no error


//successful
skipend:

except;end;

//error
if (e<>'') then gui.poperror('',e);

//clear
missize(itemp,1,1);

end;

function tapp.xsize:longint;
begin

if (mish(iimage)<=1) then result:=0
else                      result:=misw(iimage)*mish(iimage)*3;

end;

function tapp.xempty:boolean;
begin

result:=(xsize<=0);

end;

procedure tapp.xupdatebuttons;
var
   dcancopy:boolean;
begin

dcancopy                                :=not xempty;

rootwin.xhead.benabled2['new']          :=dcancopy;
rootwin.xhead.benabled2['paste']        :=clip__canpasteimage;
rootwin.xhead.benabled2['copy']         :=dcancopy;
rootwin.xhead.benabled2['copy.b64.png'] :=dcancopy;
rootwin.xhead.benabled2['save']         :=dcancopy;
rootwin.xhead.benabled2['unpack']       :=xcanunpack;

end;

procedure tapp.xsync;
var
   dsize:longint;
begin

iv.setparams2(ilastpos,0,frcmin32(mish(iimage)-32,0),false);

dsize:=xsize;
rootwin.xstatus2.celltext[0]:='Size: '+low__mbb( frcmax32(dsize,isizelimit) ,2,true)+' of '+low__mbb(isizelimit,2,true);
rootwin.xstatus2.cellpert[0]:=low__ipercentage(dsize,isizelimit);

rootwin.xstatus2.celltext[1]:='Files: '+k64(ifilecount);

rootwin.xstatus2.celltext[2]:='Color: '+xcolorlabel;

xupdatebuttons;
iscreen.paintnow;
end;

procedure tapp.xshowmenuFill1(sender:tobject;xstyle:string;xmenudata:tstr8;var ximagealign:longint;var xmenuname:string);
   procedure cadd(xval,xname:string);
   begin
   low__menuitem(xmenudata,tep__tick(color=xval),xname,'','setcolor.'+xval,0,true);
   end;
begin
try
//check
if zznil(xmenudata,5000) then exit;

if (xstyle='color') then
   begin
   low__menutitle(xmenudata,tepNone,'Color','');
   cadd('','Default');
   cadd('r','Red');
   cadd('y','Yellow');
   cadd('g','Green');
   cadd('b','Blue');
   cadd('p','Purple');
   cadd('x','Pink');
   cadd('w','White');
   end;

except;end;
end;

function tapp.xshowmenuClick1(sender:tbasiccontrol;xstyle:string;xcode:longint;xcode2:string;xtepcolor:longint):boolean;
begin
result:=true;xcmd(nil,0,xcode2);
end;

procedure tapp.xloadsettings;
var
   a:tvars8;
begin
try
//defaults
a:=nil;
//check
if zznil(prgsettings,5001) then exit;

//init
a:=vnew2(950);
//filter
a.s['color']    :=prgsettings.sdef('color','');

//sync
prgsettings.data:=a.data;

//set
color:=a.s['color'];
except;end;
//free
freeobj(@a);
iloaded:=true;
end;

procedure tapp.xsavesettings;
var
   a:tvars8;
begin
try
//check
if not iloaded then exit;

//defaults
a:=nil;
a:=vnew2(951);

//get
a.s['color']:=icolor;

//set
prgsettings.data:=a.data;
siSaveprgsettings;
except;end;
//free
freeobj(@a);
end;

procedure tapp.xautosavesettings;
var
   bol1:boolean;
begin
try
//check
if not iloaded then exit;
//get
bol1:=false;
if low__setstr(isettingsref,icolor) then bol1:=true;
//set
if bol1 then xsavesettings;
except;end;
end;

procedure tapp.__onclick(sender:tobject);
begin
try;xcmd(sender,0,'');except;end;
end;

procedure tapp.__ontimer(sender:tobject);//._ontimer
var
   e:string;
   p:longint;
begin
try
//init

if (ms64>=itimerfast) then
   begin
   if low__setint(ilastpos,iv.pos) then iscreen.paintnow;
   end;


//timer500
if (ms64>=itimer500) then
   begin
   //savesettings
   xautosavesettings;

   //buttons
   xupdatebuttons;

   //drag and drop support -> image has packed files in it -> load it, don't pack it
   if (ipacklist.count=1) then xloadit_dontpackit;

   //drag and drop support
   if (ipacklist.count>=1) then
      begin
      xpack(ipacklist,true);
      ipacklist.clear;
      end;

   //delete files in dellist - temp copies
   if (idellist.count>=1) then
      begin
      for p:=0 to (idellist.count-1) do io__remfile(app__subfolder('temp')+idellist.value[p]);
      idellist.clear;
      end;

   //reset
   itimer500:=ms64+500;
   end;

//debug tests
if system_debug then debug_tests;
except;end;
end;

procedure tapp.xloadit_dontpackit;
var
   dext,df,m,e:string;
   xwriteerrs,xcount:longint;
   xok:boolean;
begin
try
//check
if (ipacklist.count<>1) then exit;

//.must be a file
df:=ipacklist.value[0];
if io__isfolder(df) or (not io__fileexists(df)) then exit;

//.must be a lossless image
dext:=strlow(io__lastext(df));
if (dext<>'bmp') and (dext<>'png') and (dext<>'tga') and (dext<>'ppm') and (dext<>'img32') and (dext<>'tea') and (dext<>'pnm') then exit;

//get
if mis__fromfile(itemp,df,e) then
   begin
   xok:=eat__unpack(itemp,'',true,xcount,xwriteerrs,e);

   //.at least one file detected
   if (xcount>=1) then
      begin

      //ok to clear the pack list -> we've loaded the contents
      ipacklist.clear;

      //set
      m:=k64(xcount)+' file'+s(xcount)+' found.'+insstr('  Some are damaged.',not xok);
      miscopy(itemp,iimage);
      ifilecount:=xcount;
      ilastpos  :=0;
      xsync;
      gui.popstatus(m,ipopshowDelay);

      end;
   end;

except;end;
//clear
missize(itemp,1,1);
end;

procedure tapp.xcopybase64(dext:string);//27nov2025
label
   skipend;
var
   xresult:boolean;
   a:tbasicimage;
   d:tstr8;
   dtype,e:string;
begin

//defaults
xresult :=false;
d       :=nil;
a       :=nil;
e       :=gecTaskfailed;

try
//check
if xempty then exit;

//get
d:=str__new8;

if strmatch(dext,'gif') or strmatch(dext,'png') or strmatch(dext,'jpg')  then
   begin

   dtype  :=net__mimefind(dext);
   a      :=misimg32(1,1);
   if not mis__copy(iimage,a)              then goto skipend;
   if not mis__todata(a,@d,dext,e)         then goto skipend;

   end
else
   begin

   e:=gecUnsupportedFormat;
   goto skipend;

   end;

if not str__tob64(@d,@d,0)                 then goto skipend;
if not d.sins('data:'+dtype+';base64,',0)  then goto skipend;
if not clip__copytext(d.text)              then goto skipend;

//successful
xresult:=true;
gui.popstatus(low__mbAUTO2(d.len,1,true)+' of text copied to Clipboard',1);

skipend:
except;end;

//free
str__free(@d);
freeobj(@a);

//show error
if (not xresult) and (app__gui<>nil) then app__gui.poperror('',e);

end;

end.
