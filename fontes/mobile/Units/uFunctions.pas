unit uFunctions;

interface

uses FMX.Graphics, System.Net.HttpClientComponent, System.Classes,
System.SysUtils, System.Net.HttpClient;

procedure LoadImageFromURL (img: TBitmap; url : string);
function Round2(aValue: double) : Double;
function UTCtoDateBR(dt: string) : string;

implementation

{dowloand pela URL}
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

{2 casas decimais}
function Round2(aValue: double) : Double;
begin
   Round2:= Round(aValue*100)/100;
end;

{converter data Brasil}
function UTCtoDateBR(dt: string) : string;
begin
  //2023-05-07T20:27:22.000Z
  Result := Copy(dt,9,2) + '/' + Copy(dt,6,2) + '/' + Copy(dt,1,4) + ' ' + Copy(dt,12, 5);
end;
end.
