class Planck < Formula
  desc "Stand-alone OS X ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/mfikes/planck/archive/1.14.tar.gz"
  sha256 "fb46888507a6501219f09dc0d2a044dadbf55521bb48ecbf8f6ea363cda2cb02"
  head "https://github.com/mfikes/planck.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "20604286366be1064717882b2695b3d8eb1f1c08adddd7a0da8801c514d0d98f" => :el_capitan
    sha256 "3af23c0d5b5d56de59add578b27084cd748b655b626ac843f6d82ee9877b9c29" => :yosemite
    sha256 "7e2b80e0c2ce8269c6614209fe796b2286c217fc31a560b3491680ba655a490b" => :mavericks
  end

  devel do
    url "https://github.com/mfikes/planck/archive/2.0-alpha1.tar.gz"
    version "2.0-alpha1"
    sha256 "3a1438bbefa5bb6c48b8c5470a53b200198c21cb8186e42f89f93a71e9f6a072"
  end

  depends_on "leiningen" => :build
  depends_on :xcode => :build
  depends_on :macos => :mavericks

  def install
    # Fixes "No such file or directory - build/Release/planck"
    # Reported 17 Jun 2016: https://github.com/mfikes/planck/issues/322
    inreplace "script/build", "$(PWD)", "$PWD"

    system "./script/build-sandbox"
    bin.install "build/Release/planck"
  end

  test do
    system bin/"planck", "-e", "(- 1 1)"
  end
end
