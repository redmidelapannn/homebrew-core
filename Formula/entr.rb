class Entr < Formula
  desc "Run arbitrary commands when files change"
  homepage "http://entrproject.org/"
  url "http://entrproject.org/code/entr-4.4.tar.gz"
  sha256 "54566c64f360afd43f6a6065bc6d849472337edf2189b1ce34bf15b611f350f4"
  head "https://github.com/eradman/entr.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "854f264675e7ac67106adf4852b7316969b3002efcaca00a08bbb544bfca6b6c" => :catalina
    sha256 "e65d9bbd38ecb70fe114d10109142554be4514d1a2e7476e1e7f07e045bd3a25" => :mojave
    sha256 "9da217e1929de0039f80f13e91ae27231c4428843a93164b982cb4938b84d5e6" => :high_sierra
  end

  def install
    ENV["PREFIX"] = prefix
    ENV["MANPREFIX"] = man
    system "./configure"
    system "make"
    system "make", "install"
  end

  test do
    touch testpath/"test.1"
    fork do
      sleep 0.5
      touch testpath/"test.2"
    end
    assert_equal "New File", pipe_output("#{bin}/entr -p -d echo 'New File'", testpath).strip
  end
end
