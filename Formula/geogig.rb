class Geogig < Formula
  desc "Enable distributed versioning of geospatial data in a git-like context"
  homepage "http://geogig.org"
  url "http://download.locationtech.org/geogig/geogig-1.2.0.zip"
  sha256 "c438d97d8978a9d4985bd4f2ba3fff481b7956bfc4bd986ee3c79c6c07cd4f34"

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
