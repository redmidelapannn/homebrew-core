class Libdsk < Formula
  desc "Library for accessing discs and disc image files"
  homepage "https://www.seasip.info/Unix/LibDsk/"
  url "https://www.seasip.info/Unix/LibDsk/libdsk-1.4.2.tar.gz"
  sha256 "71eda9d0e33ab580cea1bb507467877d33d887cea6ec042b8d969004db89901a"

  bottle do
    cellar :any
    rebuild 1
    sha256 "bb37c44b209fffa26eb6599a76b4708e676787e8f678fa94fedac62d889c56a6" => :catalina
    sha256 "9db2b55b6655fd8e2d02ef6c1c6c2ee78a48a77630c6fe1d44f8baeeee5c3b64" => :mojave
    sha256 "89f36be6d407a5da94b8cd30caec96133860d346822f1a011c23ec3715b0eaa2" => :high_sierra
  end

  def install
    # Avoid lyx dependency
    inreplace "Makefile.in", "SUBDIRS = . include lib tools man doc",
                             "SUBDIRS = . include lib tools man"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
    doc.install Dir["doc/*.{html,pdf,sample,txt}"]
  end

  test do
    assert_equal "#{name} version #{version}\n", shell_output(bin/"dskutil --version")
  end
end
