 
<%@ page 
 import="java.util.Calendar,java.util.GregorianCalendar"
 
%>
<%
      GregorianCalendar gc = new GregorianCalendar();
      int thisyear = gc.get(Calendar.YEAR);
      String nd = String.valueOf(thisyear);
      int  int1 =15,int2=1;
      int nd1 = thisyear - int1; 
      int nd2 = thisyear + int2; 
      out.println("<option></option>");
      for (int i = nd2; i >= nd1; i--){
       String value = String.valueOf(i);
       
        if (value.equals(nd)) {
          out.println("<option value='" + value + "' selected>" + value
              + "</option>");
        } else {
         out.println("<option value='" + value + "'>" + value + "</option>");
        }
      }
%>   