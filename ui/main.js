let currentLevel = {}

let animtime,
canvas,ctx,
minusPi,
startY,
claude,
needtofinish = false,
endY;

window.onload = function(){
  canvas = document.getElementById("mainCanvas");
  ctx = canvas.getContext("2d");
  ctx.lineWidth = 20;
  minusPi = -Math.PI*0.5;
}
window.addEventListener("message",e => {
  if(e.data.action == "open"){
    needtofinish = false;
    const width = e.data.diff.width;
    startY = Math.random()*Math.PI*1.75 + minusPi;
    endY = startY + width;
    currentLevel = {
      width:width,
      alength:e.data.diff.duration,
      amountLeft:e.data.amount
    }
    animtime = undefined; 
    $("#mainCanvas").fadeIn();
    $(".load-text").fadeIn();
    ctx.clearRect(0,0,canvas.width,canvas.height);
    requestAnimationFrame(step);
  }
  if(e.data.action == "check"){
    let success = checkIsIn(claude,startY,endY)
    currentLevel.amountLeft--;
    if (!success || currentLevel.amountLeft <= 0){
      $.post("http://wasabi_fishing/finish",JSON.stringify({
        success:success
      }));
      needtofinish = true;
      return;
    }
    if(currentLevel.amountLeft > 0){
      needtofinish = false;
      startY = Math.random()*Math.PI*1.75 + minusPi;
      endY = startY + currentLevel.width;
      animtime = undefined; 
      $("#mainCanvas").fadeIn();
      $(".load-text").fadeIn();
      ctx.clearRect(0,0,canvas.width,canvas.height);
      requestAnimationFrame(step);
    }
  }
  if(e.data.action == "hide"){
    needtofinish = true;
  }
})

function step(time){
  if(animtime == undefined)
    animtime = time + currentLevel.alength;
  if(time > animtime){
    time = animtime;
  }
  if(time <= animtime) {
    claude = minusPi + Math.PI*2*(1-(animtime-time)/currentLevel.alength);
    let patrik = claude;
    if(patrik > startY)
      patrik = startY;
    ctx.clearRect(0,0,canvas.width,canvas.height);
    ctx.beginPath();
    ctx.arc(125,125,100,minusPi,Math.PI*2);
    ctx.fillStyle = "rgba(0,0,0,.6)";
    ctx.fill();
    
    ctx.lineWidth = 8.5;
    if(claude < endY){
      ctx.beginPath();
      ctx.arc(125,125,85,startY,endY);
      ctx.strokeStyle = "rgba(255,255,255,.9)";
      ctx.stroke();
    }
    ctx.beginPath();
    ctx.arc(125,125,88,minusPi,patrik);
    ctx.strokeStyle = "rgba(255,255,255,1)";
    ctx.stroke();

    ctx.beginPath();
    ctx.arc(125,125,82,minusPi,patrik);
    ctx.strokeStyle = "rgba(255,255,255,1)";
    ctx.stroke();

    ctx.beginPath();
    ctx.arc(125,125,85,minusPi,patrik);
    ctx.strokeStyle = "#009900";
    ctx.stroke();

    
    
    if (claude > startY)
    {
      if(claude > endY)
      {
        patrik = endY;
        ctx.beginPath();
        ctx.arc(125,125,88,endY,claude);
        ctx.strokeStyle = "rgba(255,255,255,1)";
        ctx.stroke();

        ctx.beginPath();
        ctx.arc(125,125,82,endY,claude);
        ctx.strokeStyle = "rgba(255,255,255,1)";
        ctx.stroke();

        ctx.beginPath();
        ctx.arc(125,125,85,endY,claude);
        ctx.strokeStyle = "#009900";
        ctx.stroke();
        
        
      }
      else
        patrik = claude;
      
      ctx.beginPath();
      ctx.arc(125,125,88,startY,patrik);
      ctx.strokeStyle = "rgba(255,255,255,1)";
      ctx.stroke();

      ctx.beginPath();
      ctx.arc(125,125,82,startY,patrik);
      ctx.strokeStyle = "rgba(255,255,255,1)";
      ctx.stroke();

      ctx.beginPath();
      ctx.arc(125,125,85,startY,patrik);
      ctx.strokeStyle = "#FF0000";
      ctx.stroke();
    }
    if (time == animtime || needtofinish){
      time = undefined;
      claude = undefined;
      $(".load-text").fadeOut(300);
      $("#mainCanvas").fadeOut(300,function(){
          ctx.clearRect(0,0,canvas.width,canvas.height);
          $.post("http://wasabi_fishing/finish",JSON.stringify({
          success:false
          }))
        });
        return false; 
    }
    requestAnimationFrame(step);
  }
}

function checkIsIn(x,s,e){
  if(s <= x && x <= e)
    return true;
  return false;
}