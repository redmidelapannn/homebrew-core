class Libsvm < Formula
  desc "Library for support vector machines"
  homepage "https://www.csie.ntu.edu.tw/~cjlin/libsvm/"
  url "https://www.csie.ntu.edu.tw/~cjlin/libsvm/libsvm-3.22.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/libsvm-3.22.tar.gz"
  sha256 "6d81c67d3b13073eb5a25aa77188f141b242ec328518fad95367ede253d0a77d"

  bottle do
    cellar :any
    rebuild 1
    sha256 "38d94b9a4bdd2b3686ac9b3ae5e5967c0a29dc4d0f561795a7d9c5bc83229dfe" => :sierra
    sha256 "1859e1a79fe238d6204ca243dcc1a739021463c23835938bcb01510e68331052" => :el_capitan
    sha256 "491a11f37fb1bdd7ae58bc119d33ab97b956e00526c0005f3d1ca38995d12cf0" => :yosemite
  end

  def install
    system "make", "CFLAGS=#{ENV.cflags}"
    system "make", "lib"
    bin.install "svm-scale", "svm-train", "svm-predict"
    lib.install "libsvm.so.2" => "libsvm.2.dylib"
    lib.install_symlink "libsvm.2.dylib" => "libsvm.dylib"
    MachO::Tools.change_dylib_id("#{lib}/libsvm.2.dylib", "#{lib}/libsvm.2.dylib")
    include.install "svm.h"
  end

  test do
    (testpath/"train_classification.txt").write <<-EOS.undent
    +1 201:1.2 3148:1.8 3983:1 4882:1
    -1 874:0.3 3652:1.1 3963:1 6179:1
    +1 1168:1.2 3318:1.2 3938:1.8 4481:1
    +1 350:1 3082:1.5 3965:1 6122:0.2
    -1 99:1 3057:1 3957:1 5838:0.3
    EOS

    (testpath/"train_regression.txt").write <<-EOS.undent
    0.23 201:1.2 3148:1.8 3983:1 4882:1
    0.33 874:0.3 3652:1.1 3963:1 6179:1
    -0.12 1168:1.2 3318:1.2 3938:1.8 4481:1
    EOS

    system "#{bin}/svm-train", "-s", "0", "train_classification.txt"
    system "#{bin}/svm-train", "-s", "3", "train_regression.txt"
  end
end
