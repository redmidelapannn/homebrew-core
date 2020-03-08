class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools.git",
      :tag      => "2.0.0",
      :revision => "2797858400171ffaa3074c22925b05ed54b634f1"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a49b76a005f002d1b4c2f9792258c13691705283ca896624d580c91c519827a6" => :catalina
    sha256 "a49b76a005f002d1b4c2f9792258c13691705283ca896624d580c91c519827a6" => :mojave
    sha256 "a49b76a005f002d1b4c2f9792258c13691705283ca896624d580c91c519827a6" => :high_sierra
  end

  depends_on "bazelisk" => :build

  def install
    system "bazelisk", "build", "--config=release", "buildifier:buildifier"
    bin.install "bazel-bin/buildifier/darwin_amd64_stripped/buildifier"
  end

  test do
    touch testpath/"BUILD"
    system "#{bin}/buildifier", "-mode=check", "BUILD"
  end
end
