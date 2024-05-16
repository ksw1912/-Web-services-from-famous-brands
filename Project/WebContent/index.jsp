<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*" %>
<%@ page import="java.io.IOException" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %> <!-- 동일한 파일명들 변경해주는 역할 -->
<%@ page import="com.oreilly.servlet.MultipartRequest" %>

<%@ page import="java.sql.*" %>
<%@ page import="server.FileUploadServlet" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>그림판</title>
<style>
#canvasContainer {
   border: 2px solid black;
   display: inline-block;
   margin: 20px auto;
   position: relative;
}

canvas {   
   display: block;
}

input[type="button"] {
   display: inline-block;
   margin: 5px;
}

 body {
    text-align: center;
    font-family: Arial, sans-serif;
    background-color: #f0f0f0; /* 배경색 변경 */
    padding: 20px;
  }

  #canvasContainer {
    border: 2px solid black;
    display: inline-block;
    margin: 20px auto;
    position: relative;
  }

  canvas {
    border: 2px solid black;
    display: block;
    margin: 0 auto;
    background-color: #ffffff; /* 캔버스 배경색 변경 */

}#buttonContainer {
    text-align: center;
    margin: 20px auto;
  }
  
  
  
 
</style>
</head>
<body>
   <h1 style="text-align: center;">그림판</h1>
   <div id="canvasContainer">
      <canvas id="drawingCanvas" width="1200" height="500"></canvas>
   </div>

   <!-- Button container for center alignment -->
   <div id="buttonContainer">
     <input type="color" id="penColorInput">
     <input type="button" value="펜 색 변경" id="changePenColorButton">
     <input type="button" value="지우개" id="eraserButton">
     <input type="button" value="초기화" id="clearCanvasButton">
   </div>

     <form action="/Project/FileUploadServlet" method="post" enctype="multipart/form-data">
     <input type="file" name="uploadFile" id="uploadImageInput" accept="image/*">   
     <input type="submit" value="첨부파일 저장" id="saveImageToServerButton">
     <input type="hidden" name="canvasImage" id="canvasImage">
   </form>
   		<form action="/Project/FileUploadServlet" method="post" enctype="multipart/form-data">
        <input type="submit" value="이미지 저장" id="saveImageToServerButton">
   		
   		</form>

   <script>
      // Canvas와 관련된 변수 설정
      var canvas = document.getElementById('drawingCanvas');
      var context = canvas.getContext('2d');
    
      var isDrawing = false;
      var isErasing = false;
      var drawingData =[];
      
      // 그리기 이벤트 처리
      canvas.addEventListener('mousedown', function(e) {   //마우스버튼 눌렀을때 
         isDrawing = true;
         if (isErasing) {
            context.clearRect(e.clientX
                  - canvas.getBoundingClientRect().left, e.clientY
                  - canvas.getBoundingClientRect().top, 10, 10);
         } else {
            context.beginPath();
            context.moveTo(e.clientX - canvas.getBoundingClientRect().left,
                  e.clientY - canvas.getBoundingClientRect().top);
         }
      });

      canvas.addEventListener('mousemove', function(e) {      //마우스 움직일때 event 발생
         if (isDrawing) {
            if (isErasing) {
               context.clearRect(e.clientX
                     - canvas.getBoundingClientRect().left, e.clientY
                     - canvas.getBoundingClientRect().top, 10, 10);
            } else {
               context.lineTo(e.clientX
                     - canvas.getBoundingClientRect().left, e.clientY
                     - canvas.getBoundingClientRect().top);
               context.stroke();
               
            }
         }
      });

      canvas.addEventListener('mouseup', function() {
         isDrawing = false;
      });

      // 지우개 변경 버튼 클릭 이벤트 처리
      var eraserButton = document.getElementById('eraserButton');
      eraserButton.addEventListener('click', function() {
         isErasing = !isErasing;
         if (isErasing) {
            eraserButton.value = "펜";
         } else {
            eraserButton.value = "지우개";
         }
      });

      // 펜 색 변경 버튼 클릭 이벤트 처리
      var penColorInput = document.getElementById('penColorInput');
      var changePenColorButton = document.getElementById('changePenColorButton');
      changePenColorButton.addEventListener('click', function() {
         context.strokeStyle = penColorInput.value;
      });
      
      // 초기화 버튼 클릭 이벤트 처리
      var clearCanvasButton = document.getElementById('clearCanvasButton');
      clearCanvasButton.addEventListener('click', function() {
         context.clearRect(0, 0, canvas.width, canvas.height);
       });

      // 이미지 저장 버튼 클릭 이벤트 처리
      var saveImageToServerButton = document.getElementById('saveImageToServerButton');
      saveImageToServerButton.addEventListener('click', function() {
         // 이미지 데이터를 Blob으로 변환
         var canvasData = canvas.toDataURL('image/png');
         var byteCharacters = atob(canvasData.split(',')[1]);
         var byteNumbers = new Array(byteCharacters.length);
         for (var i = 0; i < byteCharacters.length; i++) {
            byteNumbers[i] = byteCharacters.charCodeAt(i);
         }
         var byteArray = new Uint8Array(byteNumbers);
         var blob = new Blob([byteArray], { type: 'image/png' });

         var formData = new FormData();
         formData.append("uploadfiles", blob, "image.png");

         // fetch를 사용하여 이미지를 서버에 업로드
         fetch("/Project/FileUploadServlet", {
            method: "POST",
            body: formData   
         })
         .then(response => {
            if (response.ok) {
               alert("이미지가 서버에 업로드되었습니다.");
            } else {   
               return response.text().then(errorText => {
                  console.error(errorText);
                  alert("이미지 업로드 중 오류가 발생했습니다: " + errorText);
               });
            }
         })
         .catch(error => {   
            console.error(error);
            alert("이미지 업로드 중 오류가 발생했습니다.");
         });
      });
      
      // 이미지 가져오기 버튼 클릭 이벤트 처리
      var uploadImageInput = document.getElementById('uploadImageInput');
      var canvasImageInput = document.getElementById('canvasImage');
      uploadImageInput.addEventListener('click', function(e) {
          var file = e.target.files[0];

          if (file) {
              var reader = new FileReader();

              reader.onload = function(e) {
                  var image = new Image();
                  image.src = e.target.result;

                  image.onload = function() {
                      context.drawImage(image, 0, 0, canvas.width,
                          canvas.height);
                  };
              };

              reader.readAsDataURL(file);
         
              // 이미지 데이터를 Blob으로 변환
              var canvasData = canvas.toDataURL('image/png');
              var byteCharacters = atob(canvasData.split(',	')[1]);
              var byteNumbers = new Array(byteCharacters.length);
              for (var i = 0; i < byteCharacters.length; i++) {
                 byteNumbers[i] = byteCharacters.charCodeAt(i);
              }
              var byteArray = new Uint8Array(byteNumbers);	
              var blob = new Blob([byteArray], { type: 'image/png' });

              var formData = new FormData();
              formData.append("uploadfiles", blob, "image.png");

              // fetch를 사용하여 이미지를 서버에 업로드
              fetch("/Project/FileUploadServlet", {
                 method: "POST",
                 body: formData   
              })
              .then(response => {
                 if (response.ok) {
                    alert("이미지가 서버에 업로드되었습니다.");
                 } else {   
                    return response.text().then(errorText => {
                       console.error(errorText);
                       alert("이미지 업로드 중 오류가 발생했습니다: " + errorText);
                    });
                 }
                
              })
              .catch(error => {   
                 console.error(error);
                 alert("이미지 업로드 중 오류가 발생했습니다.");
              });
           
          
          }
          
      });

      
   </script>
</body>
</html>
