class Apkparser < Formula
  desc "Android apk file parsing tool"
  homepage "https://github.com/wswenyue/apkparser"
  url "https://github.com/wswenyue/apkparser/archive/apkparser-1.0.0.tar.gz"
  sha256 "c002f5f735e1d30502acf06206d0fda05beba1976ede4581250f0ddbc9056a1b"

  bottle do
    cellar :any_skip_relocation
    sha256 "49a99a63445da113f7ed1ffc3e330ba46ad0d2fee1c77fea0e90f5deb4f0e7d4" => :high_sierra
    sha256 "49a99a63445da113f7ed1ffc3e330ba46ad0d2fee1c77fea0e90f5deb4f0e7d4" => :sierra
    sha256 "49a99a63445da113f7ed1ffc3e330ba46ad0d2fee1c77fea0e90f5deb4f0e7d4" => :el_capitan
  end

  def install
    libexec.install Dir["*"]
    bin.install libexec/"apkparser" => "apkparser"
    inreplace bin/"apkparser", "exe_path", "#{libexec}"
  end

  test do
    system "false"
  end
end
