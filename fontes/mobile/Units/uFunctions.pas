unit uFunctions;

interface

uses FMX.Graphics, System.Net.HttpClientComponent, System.Classes,
System.SysUtils, System.Net.HttpClient;

procedure LoadImageFromURL (img: TBitmap; url : string);
function Round2(aValue: double) : Double;

implementation

//dowloand pela URL
procedure LoadImageFromURL (img: TBitmap; url : string);
var
  http: TNetHttpClient;
  vStream : TMemoryStream;
begin
  try
    try
      http := TNetHTTPClient.Create(nil);
      vStream := TMemoryStream.Create;

      if (Pos('https', LowerCase(url)) > 0) then
        HTTP.SecureProtocols := [THTTPSecureProtocol.TLS1,
                                 THTTPSecureProtocol.TLS11,
                                 THTTPSecureProtocol.TLS12];
     http.Get(url, vStream);
     vStream.Position :=0;

     img.LoadFromStream(vStream);

    except
    end;

  finally
    vStream.DisposeOf;
    http.DisposeOf;
  end;
end;


function Round2(aValue: double) : Double;
begin
   Round2:= Round(aValue*100)/100;
end;
end.
