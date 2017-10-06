class Pngquant < Formula
  desc "PNG image optimizing utility"
  homepage "https://pngquant.org/"
  url "https://github.com/pornel/pngquant.git",
      :tag => "2.10.2",
      :revision => "f10f5d217c170d7aff4d80b88bdc563bd56babef"
  head "https://github.com/pornel/pngquant.git"

  bottle do
    rebuild 1
    sha256 "4e096c61be59e8a95f819ce76d2a99b8502e47ec662077ac99013963986c3f86" => :high_sierra
    sha256 "bff5d35fd65ff42a5eed6ae0c54ed357439301f8c36514baab6114ea25658acf" => :sierra
    sha256 "ae8a2cce7868c268624009984913adf24b7e922562c31518ae85faaddf69b49f" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libpng"
  depends_on "little-cms2"

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/pngquant"
    man1.install "pngquant.1"
  end

  test do
    system "#{bin}/pngquant", test_fixtures("test.png"), "-o", "out.png"
    assert_predicate testpath/"out.png", :exist?
  end
end
