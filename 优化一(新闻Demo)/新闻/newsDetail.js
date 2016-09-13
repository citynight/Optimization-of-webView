window.onload = function(){
//    alert(0);
    
    // 拿到所有的图片
    var allImg = document.getElementsByTagName("img");
//    alert(allImg.length);
    // 遍历
    for(var i=0; i<allImg.length; i++){
       // 取出单个图片对象
        var img = allImg[i];
        img.id = i;
       // 监听点击
        img.onclick = function(){
//            alert('点击了第'+this.id+'张');
            // 跳转
//            window.location.href = 'http://www.baidu.com';
            window.location.href = 'mk:///openCamera'
        }
    }
    
    // 往网页尾部加入一张图片
    var img = document.createElement('img');
    img.src = 'https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/bd_logo1_31bdc765.png';
    document.body.appendChild(img);
    
    
}
