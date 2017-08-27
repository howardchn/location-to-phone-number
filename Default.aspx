<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default"
    Theme="default" %>

<!DOCTYPE HTML>
<html>
<head runat="server">
    <title>Mobile Phone Locator</title>
</head>
<body onload="initialize();">
    <form id="form1" runat="server">
        <div id="root">
            <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true">
            </asp:ScriptManager>

            <div id="map"></div>
            <div class="interaction-panel">
                <input type="text" id="iptCode" maxlength="11" class="code" placeholder="Phone number" />
                <input type="button" value="Lookup" onclick="lookup()" class="btsub" />
                <input type="checkbox" checked="checked" id="lock" />
                <span style="font-size: 10px; font-family: Verdana;">Lock current zoom.</span>
            </div>
        </div>
    </form>

    <script src="http://maps.google.com/maps?file=api&amp;v=2.x&amp;key=AIzaSyD1ALJ7CXfNuzSWVwP1B0Sl_FqGxNWLarU" type="text/javascript"></script>

    <script type="text/javascript">
        var map = null;
        var markers = [];
        var markerClusterer = null;

        function initialize() {
            if (GBrowserIsCompatible()) {
                map = new GMap2(document.getElementById('map'));
                map.setCenter(new GLatLng(35, 106.38), 4);
                map.addControl(new GLargeMapControl());
                map.addControl(new GMapTypeControl());
                var icon = new GIcon(G_DEFAULT_ICON);
                icon.image = "http://chart.apis.google.com/chart?cht=mm&chs=24x32&chco=FFFFFF,008CFF,000000&ext=.png";
            }
        }

        var marker = null;
        var lookup = function () {
            var code = $get("iptCode").value;
            PageMethods.GetMobileCodeInfo(code, lookupCompleted);
        }

        var lookupCompleted = function (text) {
            var index = text.indexOf('：');
            if (index != -1) {
                var code = text.substring(0, index);
                var description = text.substring(index + 1, text.length);
                var locations = description.split(' ');
                var location = locations[1];
                var message = '<span class="highlight">' + code + '</span><br/><br/>';
                message += '<span class="nortxt">'

                for (var i = 0; i < locations.length; i++) {
                    message += locations[i];
                    if (i != locations.length - 1)
                        message += ',';
                }

                message += '</span>'

                var geocoder = new GClientGeocoder();
                geocoder.getLatLng(location, function (point) {
                    if (!point) {
                        alert(location + " not found.");
                    } else {
                        if ($get('lock').checked) {
                            map.setCenter(point, 4);
                        } else {
                            map.setCenter(point, 8);
                        }

                        if (marker != null) {
                            map.removeOverlay(marker);
                        }

                        marker = new GMarker(point);
                        map.addOverlay(marker);
                        marker.openInfoWindowHtml(message);
                    }
                });
            }
        }
    </script>
</body>
</html>
