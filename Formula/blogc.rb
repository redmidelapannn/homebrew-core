class Blogc < Formula
  desc "Static blog compiler"
  homepage "https://blogc.rgm.io"
  url "https://github.com/blogc/blogc/releases/download/v0.12.0/blogc-0.12.0.tar.bz2"
  sha256 "421474fa089024015f7dca77386c3ca360531ae4510ae50b4dc3446653a4edbe"

  bottle do
    cellar :any_skip_relocation
    sha256 "f4129af3968c1291a35d81b1b9e1dd3ba008e544083dbc664d0cb660e9fadd3e" => :sierra
    sha256 "f71f2fdcc2a255c0185c1ae84e507522e33f80f3c3d1891590e824e7ae8fba70" => :el_capitan
    sha256 "52dde066aa9775714fe31c398c1fa6192e47db06bb356f36f26defa7b220929c" => :yosemite
  end

  def install
    system "./configure", "--enable-runserver",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "git", "clone", "https://github.com/blogc/blogc-example.git"
    system "#{bin}/blogc", "-t", "blogc-example/templates/main.tmpl", "blogc-example/content/post/post1.txt"
  end
end
