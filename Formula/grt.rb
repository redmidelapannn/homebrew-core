class Grt < Formula
  desc "The Gesture Recognition Toolkit for real-time machine learning"
  homepage "https://www.nickgillian.com/wiki/pmwiki.php/GRT/GestureRecognitionToolkit"
  url "https://github.com/nickgillian/grt/archive/v0.0.1.tar.gz"
  sha256 "56f90a9ffa8b2bf4e5831d39f9e1912879cf032efa667a5237b57f68800a2dda"

  bottle do
    cellar :any
    revision 1
    sha256 "afa3a71cc84e3931a06d28948456d1cf8aeee770ed19b7308ecbd4bd7b7218bf" => :el_capitan
    sha256 "d35d948b9b0de73732ebd33fc90eda6444c59942d717625455355277f46d5118" => :yosemite
    sha256 "baf0aa3fa36065e387e5031e1f6ec80689b16e57ad2df55f7db81766ff62cda1" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    cd "build"
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <GRT/GRT.h>
      int main() {
        GRT::GestureRecognitionPipeline pipeline;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lgrt", "-o", "test"
    system "./test"
  end
end
