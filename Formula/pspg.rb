class Pspg < Formula
  desc "Postgres Pager"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/v0.3.tar.gz"
  sha256 "a1559a86c8d6a7c8b9548073c5b8572e8b5aa37e931261202084fd7c6906a7be"

  bottle do
    cellar :any_skip_relocation
    sha256 "356924fc6bfd261b8e50864247cd7a24d3343f0e34deb0ea3ace397dc80201d3" => :high_sierra
    sha256 "3177b064b111aaee603b333d9ebb53316aa4e533e178dc3b77b7ea90018a17c9" => :sierra
    sha256 "3281f952396ef477aa33be9c4c2c476fbe1a546445c1f039ccaa1bac5b023684" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    require "open3"

    expected = <<-ERR.undent
    pspg-0.3-devel
    ERR

    command = "#{bin}/pspg -V"

    stdout_str, stderr_str, status = Open3.capture3(command)

    assert_equal(expected, stdout_str)
  end
end
