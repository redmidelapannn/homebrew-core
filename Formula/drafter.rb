class Drafter < Formula
  desc "Native C/C++ API Blueprint Parser"
  homepage "https://apiblueprint.org/"
  url "https://github.com/apiaryio/drafter/releases/download/v3.2.7/drafter-v3.2.7.tar.gz"
  sha256 "a2b7061e2524804f153ac2e80f6367ae65dfcd367f4ee406eddecc6303f7f7ef"

  bottle do
    cellar :any
    rebuild 1
    sha256 "0a5733048972f618798474f84d3c8d17382e4c04231d1cd603f8877e6ccd2f74" => :mojave
    sha256 "1d2cce9f3e2b882fa33e7871efbcc0b1217f4632f00bbc6fdd45a3fedbc4f053" => :high_sierra
    sha256 "2d1810ca95f1553c75cf7f2fdc63d05d593e64d2d2cd8f177cf0fa7bd1f4c10b" => :sierra
  end

  def install
    system "./configure", "--shared"
    system "make", "drafter"

    bin.install "bin/drafter"
    (include + "drafter").install "src/drafter.h"
    lib.install "build/out/Release/libdrafter.dylib"
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
