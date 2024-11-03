const express =require("express");
const app =express();


app.get("/",(req,res)=>{
    res.send("helo w node js  ")
})

app.listen(8080,()=>{
    console.log("listing to http://localhost:8080");
    
})