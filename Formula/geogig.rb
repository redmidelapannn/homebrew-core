class Geogig < Formula
  desc "Enable distributed versioning of geospatial data in a git-like context"
  homepage "http://geogig.org"
  url "http://download.locationtech.org/geogig/geogig-1.2.0.zip"
  sha256 "c438d97d8978a9d4985bd4f2ba3fff481b7956bfc4bd986ee3c79c6c07cd4f34"

  bottle do
    cellar :any_skip_relocation
    sha256 "e04d8dc154b892c9c4ad5711840475a9fc038f2a472c5c2b502d953fc594c533" => :high_sierra
    sha256 "c2f671a71f3d3eb631769beca1555e26672afb03dcdeb0a81471b99aadd24094" => :el_capitan
  end

  depends_on :java => ["1.8+", :recommended]

  def install
    args << "--without-java" if build.without? "java"

    bin.install "bin/geogig"
    prefix.install "libexec"
    prefix.install "misc"
  end

  test do
    system "#{bin}/geogig", "init"
    system "#{bin}/geogig", "status"
  end
end
