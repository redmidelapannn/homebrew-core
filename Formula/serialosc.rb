class Serialosc < Formula
  desc "Opensound control server for monome devices"
  homepage "https://monome.org/docs/osc/"
  url "https://github.com/monome/serialosc.git",
      :tag      => "v1.4.1",
      :revision => "4fec6f11276dd302faf9ca8e0a8e126f273cf954"
  revision 1
  head "https://github.com/monome/serialosc.git"

  bottle do
    cellar :any
    sha256 "b88cda89748c22fb915f5068441d545348f4d5b96b66e8b4f8f959c54b74bbc0" => :sierra
  end

  depends_on "confuse"
  depends_on "liblo"
  depends_on "libmonome"

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/serialoscd -v")
  end
end
