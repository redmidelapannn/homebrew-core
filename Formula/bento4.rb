class Bento4 < Formula
  desc "Full-featured MP4 format and MPEG DASH library and tools"
  homepage "https://www.bento4.com/"
  url "https://github.com/axiomatic-systems/Bento4/archive/v1.5.1-624.tar.gz"
  version "1.5.1-624"
  sha256 "eda725298e77df83e51793508a3a2640eabdfda1abc8aa841eca69983de83a4c"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "99363a92066923f052ba445b9f06c73cbcc3744068177200e15b61adaac9df91" => :high_sierra
    sha256 "4024ad3fcb368890461619dcd7b0cd497bac24581a4d7628ce5e6a5962ed9445" => :sierra
    sha256 "335137de689a97bf0d4537074afc19bbf97ecce787dc6b89a80b7b3cc6d5a575" => :el_capitan
  end

  depends_on :xcode => :build
  depends_on "python@2"

  conflicts_with "gpac", :because => "both install `mp42ts` binaries"
  conflicts_with "mp4v2",
    :because => "both install `mp4extract` and `mp4info` binaries"

  def install
    cd "Build/Targets/universal-apple-macosx" do
      xcodebuild "-target", "All", "-configuration", "Release", "SYMROOT=build"
      programs = Dir["build/Release/*"].select do |f|
        next if f.end_with? ".dylib"
        next if f.end_with? "Test"
        File.file?(f) && File.executable?(f)
      end
      bin.install programs
    end

    rm Dir["Source/Python/wrappers/*.bat"]
    inreplace Dir["Source/Python/wrappers/*"],
              "BASEDIR=$(dirname $0)", "BASEDIR=#{libexec}/Python/wrappers"
    libexec.install "Source/Python"
    bin.install_symlink Dir[libexec/"Python/wrappers/*"]
  end

  test do
    system "#{bin}/mp4mux", "--track", test_fixtures("test.m4a"), "out.mp4"
    assert_predicate testpath/"out.mp4", :exist?, "Failed to create out.mp4!"
  end
end
