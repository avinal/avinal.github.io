********
About Me
********

:slug: about-me

.. raw:: html

    <div id="adobe-dc-view" style="width: 800px;" align=center></div>
    <script src="https://documentcloud.adobe.com/view-sdk/main.js"></script>
    <script type="text/javascript">
	document.addEventListener("adobe_dc_view_sdk.ready", function(){ 
		var adobeDCView = new AdobeDC.View({clientId: "987d3bec94ec4052ab3278c948418e65", divId: "adobe-dc-view"});
		adobeDCView.previewFile({
			content:{location: {url: "https://github.com/avinal/avinal/blob/main/avinal_kumar.pdf"}},
			metaData:{fileName: "avinal_kumar.pdf"}
		}, {embedMode: "IN_LINE"});
	});
    </script>
