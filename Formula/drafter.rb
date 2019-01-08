class Drafter < Formula
  desc "Native C/C++ API Blueprint Parser"
  homepage "https://apiblueprint.org/"
  url "https://github.com/apiaryio/drafter/releases/download/v4.0.0-pre.2/drafter-v4.0.0-pre.2.tar.gz"
  sha256 "70f5af31f65c4b2110d4daa3e5430484f90987ee26522920c661929454e0cf0e"

  bottle do
    cellar :any_skip_relocation
    sha256 "8f224f4b9e787908d7752dfec8ee376f58d9b754e55ad4cb2486afbe93114f19" => :mojave
    sha256 "3eb828078f7cfec605a873fbef16b5ac4ddcd2ad9322e65f0418b33077e60b5d" => :high_sierra
    sha256 "374ed2a4d9f14519004cac08d2799b97985bccb6f22dbc4a641edebd2812bb83" => :sierra
  end

  def install
    system "./configure"
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    (testpath/"api.apib").write <<~EOS
      # Homebrew API [/brew]

      ## Retrieve All Formula [GET /Formula]
      + Response 200 (application/json)
        + Attributes (array)
    EOS
    assert_equal "OK.", shell_output("#{bin}/drafter -l api.apib 2>&1").strip
  end
end
