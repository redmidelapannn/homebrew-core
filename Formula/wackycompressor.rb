# Documentation: https://github.com/Homebrew/brew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Wackycompressor < Formula
  desc ""
  homepage ""
  url "https://github.com/hodgeswt/WackyCompressor/archive/1.2.0.tar.gz"
  version "1.2.0"
  sha256 "7fc69e91fe8cec29a5c9ea26b84691d87d4a4f48e88d900b67b368a9a8b8b61b"

  bottle do
    cellar :any
    sha256 "b77fbd9fac8f439c109b911bdca302b2684c4bb2e27cd4ede4cab274589b3924" => :el_capitan
    sha256 "29a4431b13ea619fa07c4809ff08868a5b828342cb02e077c8ccbf893cb2954c" => :yosemite
    sha256 "c58265aa5d6461160ce6964af954faad7a9ddc1bf22ebfbe19b07cec81ad2023" => :mavericks
  end

  # depends_on "cmake" => :build
  depends_on :x11 # if your formula requires any X11/XQuartz components

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    # Remove unrecognized options if warned by configure
    bin.install Dir["wacky/*"]
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test WackyCompressor`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
