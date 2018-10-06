class Atf < Formula
  desc "ATF: Automated Testing Framework"
  homepage "https://github.com/jmmv/atf"
  url "https://github.com/jmmv/atf/releases/download/atf-0.21/atf-0.21.tar.gz"
  sha256 "92bc64180135eea8fe84c91c9f894e678767764f6dbc8482021d4dde09857505"

  bottle do
    rebuild 1
    sha256 "f30ff853cd476c8c8f8bb6876791318e23e90de62096860a8249284a1b63cf6f" => :mojave
    sha256 "80ee9445903dee9ae426234e6b07507bb80c399eef71dd27cfd793dd1b5b22a8" => :high_sierra
    sha256 "288e87d9c8fd450e358badfbea1102f680f49f7a94058f16f9140b88eb07b671" => :sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    (testpath/"test.sh").write <<~EOS
      #!/usr/bin/env atf-sh
      echo test
      exit 0
    EOS
    system "bash", "test.sh"
  end
end
