@echo off
set /p frame="Enter Frame Number: "
echo ***
echo %frame%

ffmpeg.exe -hide_banner -i %1 -vf select=gte(n\,%frame%) -vframes 1 original.png
ffmpeg.exe -hide_banner -i original.png -pix_fmt yuv420p originalyuv420p.yuv

ffmpeg.exe -hide_banner -s:v 1920x1080 -i originalyuv420p.yuv -f yuv4mpegpipe - | x265_x64.exe --y4m --crf 18 --output encode1.265 -
ffmpeg.exe -hide_banner -s:v 1920x1080 -i originalyuv420p.yuv -f yuv4mpegpipe - | x265_x64.exe --y4m --crf 18 --profile main10 --output-depth 10 --output encode2.265 -
ffmpeg.exe -hide_banner -s:v 1920x1080 -i originalyuv420p.yuv -f yuv4mpegpipe - | x265_x64.exe --y4m --crf 22 --profile main10 --output-depth 10 --output encode3.265 -
ffmpeg.exe -hide_banner -s:v 1920x1080 -i originalyuv420p.yuv -f yuv4mpegpipe - | x265_x64.exe --y4m --crf 22 --profile main10 --output-depth 10 --tune grain --output encode4.265 -

ffmpeg.exe -hide_banner -y -i encode1.265 -vframes 1 encode1.png
ffmpeg.exe -hide_banner -y -i encode2.265 -vframes 1 encode2.png
ffmpeg.exe -hide_banner -y -i encode3.265 -vframes 1 encode3.png
ffmpeg.exe -hide_banner -y -i encode3.265 -vframes 1 encode4.png

pause
del originalyuv420p.yuv 
del encode1.265 
del encode2.265
del encode3.265
del encode4.265
