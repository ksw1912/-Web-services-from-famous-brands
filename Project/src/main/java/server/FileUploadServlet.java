package server;

import java.util.logging.Logger;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Collection;
import java.util.Date;
import java.util.UUID;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.http.Part;

import Shell.*;
import server.*;

@WebServlet("/FileUploadServlet")
@MultipartConfig(maxFileSize = 1024 * 1024 * 10,// 최대 10MB 파일 업로드 허용
fileSizeThreshold = 1024 * 1024, // 1MB까지의 파일은 메모리에 보관
maxRequestSize = 1024 * 1024 * 50 // 최대 요청 크기는 50MB

      ) 

public class FileUploadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(FileUploadServlet.class.getName());

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       
       
    
            
       ServletContext context = getServletContext();
        String SAVE_DIRECTORY = context.getRealPath("/uploads");
      
        
        // 현재 날짜 얻어서 파일명에 붙이기
        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy");//년도
        String fileDate = sdf.format(date);
        
        Date date1 = new Date();
        SimpleDateFormat sdf1 = new SimpleDateFormat("MM");//월
        String fileDate1 = sdf1.format(date1);
        
        Date date2 = new Date();
        SimpleDateFormat sdf2 = new SimpleDateFormat("dd");//일
        String fileDate2 = sdf2.format(date2);
        
        System.out.println(fileDate);
        System.out.println(fileDate1);
        System.out.println(fileDate2);
        
        
        
        
        

        // 현재 경로에 현재날짜폴더 생성하기
        String uploadPath = SAVE_DIRECTORY;
        
        File uploadDir = new File(SAVE_DIRECTORY+File.separator  + fileDate+File.separator  + fileDate1+File.separator  + fileDate2);
        if(uploadDir.exists()== false) {
         uploadDir.mkdirs();
      }
        
       
                       
        
        
        
        // 업로드 디렉토리 실제 경로를 출력
        System.out.println("업로드 디렉토리 실제 경로: " +SAVE_DIRECTORY );

        //response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();
        //out.println("<p>hello</p>");
        //out.print("</h1></body></html>");
       //out.close(); // PrintWriter 닫기

        
        
        String newFileName = null;
        
        try {
            Collection<Part> parts = request.getParts();
            for (Part part : parts) {
                if (part.getName().equals("uploadfiles")) {
                    
                   
                   String submittedFileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();//주소 제거 
                    String filename = uploadDir  + File.separator + submittedFileName;//파일위치
                    
                    try (InputStream inputStream = part.getInputStream()) {       
                       
                         String extension = part.getSubmittedFileName().substring(
                                  part.getSubmittedFileName().lastIndexOf(".")
                              );

                          newFileName = UUID.randomUUID().toString() + extension;//파일명 랜덤 변경
                         
                       
                       
                        
                        part.write(uploadPath + File.separator  + fileDate+File.separator  + fileDate1+File.separator  + fileDate2 +File.separator + newFileName);//해당경로로 이미지 저장
                        
                        part.delete();
                        
                        response.getWriter().println("파일이 성공적으로 업로드되었습니다.");
                        logger.info("파일 업로드 성공: " + filename);
                        logger.info(SAVE_DIRECTORY);
                        
                    
            response.getWriter().println("파일이 성공적으로 업로드되었습니다.");
                    
      } catch (IOException e) {
         e.printStackTrace();
         response.getWriter().println("파일 업로드 중 오류(IOException)가 발생했습니다.");
         logger.severe("파일 업로드 중 오류 : " + e.getMessage());
      } 
      //  out.print("</h1></body></html>");
       //out.close(); // PrintWriter 닫기
    } 
}
          BrandNameFinder bf = new BrandNameFinder();
            
             String brandName = bf.FindBrandName(uploadPath + File.separator  + fileDate+File.separator  + fileDate1+File.separator  + fileDate2 +File.separator+newFileName);
            // String brandName ="Nike";
             
             BrandDTO brand = new BrandDTO();
             BrandDAO brandDao = new BrandDAO();
             brand.setBrand_address(brandDao.getBrandAddress(brandName));
             
             //콘솔로 잘 되는지 여부   
             if(brand.getBrand_address() == null) System.out.println(brand.getBrand_address()+"xxxx");
             else System.out.println(brand.getBrand_address());
            
            //현재 이 위에까지는 문제 x
            
//          request.setAttribute("BrandName", brandName);
//          request.setAttribute("link", brand.getBrand_address());
//          request.getRequestDispatcher("./result.jsp").include(request, response);
//          
//          response.setCharacterEncoding("UTF-8");
//          
//          String path = request.getSession().getServletContext().getRealPath("/");
//          
//
//          
//          String content = request.getParameter("content");       
//          request.setAttribute("content", content);
//          
//          ServletContext context1 = getServletContext();
//          RequestDispatcher dispatcher = context1.getRequestDispatcher("/"+path+"WebContent\\result.jsp"); //넘길 페이지 주소
//          dispatcher.include(request, response);
//          request.getRequestDispatcher(path+"WebContent/result.jsp").include(request, response);
//          out.print("</h1></body></html>");
//          
//          response.setHeader("Location", request.getContextPath() + "/result.jsp");
             
          
          
             //response.reset();
             //response.setContentType("text/html;charset=euc-kr");
              
              request.setAttribute("BrandName", brandName);
              request.setAttribute("link", brand.getBrand_address());
                                                  System.out.println("문제없는지 check 1");
              
         //     String content = request.getParameter("content");
           //   request.setAttribute("content", content);
             // String path = request.getServletContext().getRealPath("/");
                                                  System.out.println("문제없는지 check 2");
              
              
              response.getWriter().println("파일이 성공적으로 업로드되었습니다.");
          
//              RequestDispatcher dispatcher=request.getRequestDispatcher(adjustedPath);
//              dispatcher.forward(request, response);
//              response.sendRedirect("result.jsp");
              
              
              
              
              //절대경로
         //    String adjustedPath = "/result.jsp";
           //RequestDispatcher rd =getServletContext().getRequestDispatcher(adjustedPath);
           //rd.forward(request,response);
              //String resultPageURL = path+"result.jsp";
            
              
              
              
              //상대경로
              RequestDispatcher dispatcher = request.getRequestDispatcher("result.jsp");
              dispatcher.forward(request, response);
              //response.sendRedirect("result.jsp");
              
                 
              //response.sendRedirect(resultPageURL);

             //  out.print("</h1></body></html>");
             // out.close(); // PrintWriter 닫기
              
              
              
              
             // System.out.println("result.jsp경로:"+path+"result.jsp");
              
              
  
        }catch (ServletException e) {
         e.printStackTrace();
         response.getWriter().println("잘못된 요청입니다(ServletException).");
         logger.severe("잘못된 요청 : " + e.getMessage());
      }    
        catch(Exception e){
           response.getWriter().println("잘못된 요청입니다(ServletException).");
         logger.severe("잘못된 요청1 : " + e.getMessage());
        }
        }
}