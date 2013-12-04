// porting from here: http://felix.abecassis.me/2011/09/opencv-morphological-skeleton/

import gab.opencv.*;
import org.opencv.imgproc.Imgproc;
import org.opencv.core.Size;
import org.opencv.core.Core;
import org.opencv.core.Core.MinMaxLocResult;
import org.opencv.core.Mat;

PImage src;
OpenCV opencv;

void setup() {
  src = loadImage("thin.jpg");
  size(src.width*2, src.height);
  opencv = new OpenCV(this, src);

  opencv.threshold(125);
  opencv.invert();

  Mat kernel = Imgproc.getStructuringElement(Imgproc.MORPH_CROSS, new Size(3, 3));

  boolean done = false;

  Mat temp = OpenCV.imitate(opencv.getGray());
  Mat skeleton = OpenCV.imitate(opencv.getGray());


  while (!done) {
    Imgproc.morphologyEx(opencv.getGray(), temp, Imgproc.MORPH_OPEN, kernel );

    Core.bitwise_not(temp, temp);
    Core.bitwise_and(opencv.getGray(), temp, temp);
    Core.bitwise_or(skeleton, temp, skeleton);
    Imgproc.erode(opencv.getGray(), opencv.getGray(), kernel);
    MinMaxLocResult r = Core.minMaxLoc(opencv.getGray());
    println("max: " + r.maxVal);
    if (r.maxVal == 0) {
      done = true;
    }
  }

  opencv.setGray(skeleton);
}

void draw() {
  image(src, 0, 0);
  image(opencv.getOutput(), src.width, 0);
}

