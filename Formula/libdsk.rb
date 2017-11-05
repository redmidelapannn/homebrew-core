class Libdsk < Formula
  desc "Library for accessing discs and disc image files"
  homepage "https://www.seasip.info/Unix/LibDsk/"
  url "https://www.seasip.info/Unix/LibDsk/libdsk-1.4.2.tar.gz"
  sha256 "71eda9d0e33ab580cea1bb507467877d33d887cea6ec042b8d969004db89901a"

  bottle do
    rebuild 1
    sha256 "77853d48a7c18def3aa9b47e5126f35066aacf53a229f073bf58cd7987a0fe19" => :high_sierra
    sha256 "60285273a2fa169c1a7505831ae1a41ef957999a551c1b91137d8b3a242806f2" => :sierra
    sha256 "ae290eeca80f80bba67e55ff45f97f0365d799a8ba68cd009f9044dcd9aa8047" => :el_capitan
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
