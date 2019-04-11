<%@ page language="java" pageEncoding="UTF-8"%>
<%!
  private byte[] decodeBase64(String base64String) {
    base64String = base64String.replaceAll("\r","").replaceAll("\n","");
    byte[] base64Alphabet = new byte[255];
    
   

    //create base64 alphabet
    int i;
    for (i = 0; i < 255; ++i) base64Alphabet[i] = -1;
    for (i = 90; i >= 65; --i) base64Alphabet[i] = (byte)(i - 65);
    for (i = 122; i >= 97; --i) base64Alphabet[i] = (byte)(i - 97 + 26);
    for (i = 57; i >= 48; --i) base64Alphabet[i] = (byte)(i - 48 + 52);
    base64Alphabet[43] = 62;
    base64Alphabet[47] = 63;

    //decoding
    byte[] base64Data = base64String.getBytes();

    int numberQuadruple = base64Data.length / 4;
    byte[] decodedData = (byte[])null;

    int encodedIndex = 0;
    int dataIndex = 0;

    int lastData = base64Data.length;

    while (base64Data[(lastData - 1)] == 61)
      if (--lastData == 0)
        throw new Error();

    decodedData = new byte[lastData - numberQuadruple];

    for (i = 0;i<numberQuadruple;++i) {
      dataIndex = i * 4;
      int marker0 = base64Data[(dataIndex + 2)];
      int marker1 = base64Data[(dataIndex + 3)];

      int b1 = base64Alphabet[base64Data[dataIndex]];
      int b2 = base64Alphabet[base64Data[(dataIndex + 1)]];
      int b3;
      int b4;

      if ((marker0 != 61) && (marker1 != 61)) {
        b3 = base64Alphabet[marker0];
        b4 = base64Alphabet[marker1];
        decodedData[encodedIndex] = (byte)(b1 << 2 | b2 >> 4);
        decodedData[(encodedIndex + 1)] = (byte)((b2 & 0xF) << 4 | b3 >> 2 & 0xF);
        decodedData[(encodedIndex + 2)] = (byte)(b3 << 6 | b4);
      }else if (marker0 == 61) {
        decodedData[encodedIndex] = (byte)(b1 << 2 | b2 >> 4);
      }else if (marker1 == 61) {
        b3 = base64Alphabet[marker0];
        decodedData[encodedIndex] = (byte)(b1 << 2 | b2 >> 4);
        decodedData[(encodedIndex + 1)] = (byte)((b2 & 0xF) << 4 | b3 >> 2 & 0xF);
      }
      encodedIndex += 3;
    }
    
    return decodedData;
  }
%>

<%
  String contentType = request.getParameter("contentType");
  String fileName = request.getParameter("fileName");
  
  response.reset();
  
  System.out.println("Any Chart导出图片--------------->PNG");
   
  if (contentType != null && !contentType.equals(""))
	response.setContentType(request.getParameter("contentType")); 
  else
	response.setContentType("image/png"); 
  
  if (fileName != null && !fileName.equals("")) {
    response.setHeader("Content-Disposition", "attachment; filename=\""+request.getParameter("fileName")+"\"");
  }
  
  response.getOutputStream().write(decodeBase64(request.getParameter("file")));
  out.clear();
  out = pageContext.pushBody();
%>