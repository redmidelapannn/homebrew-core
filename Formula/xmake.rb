class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://github.com/xmake-io/xmake/releases/download/v2.3.2/xmake-v2.3.2.tar.gz"
  sha256 "704dba105dd46ee50a08e64ebbfd93ad89c61b0b6bbd399482cb371cba969930"
  head "https://github.com/xmake-io/xmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b0b0b49c5505064f643fb8eaa1f26ae68c30c650505f17bd43b9005edddc048f" => :catalina
  end

  def install
    system "make", "build"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system bin/"xmake", "create", "test"
    cd "test" do
      system bin/"xmake"
      assert_equal "hello world!", shell_output("#{bin}/xmake run").chomp
    end
  end
end
