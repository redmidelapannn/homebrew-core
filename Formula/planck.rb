class Planck < Formula
  desc "Stand-alone OS X ClojureScript REPL"
  homepage "http://planck-repl.org/"
  url "https://github.com/mfikes/planck/archive/1.14.tar.gz"
  sha256 "fb46888507a6501219f09dc0d2a044dadbf55521bb48ecbf8f6ea363cda2cb02"
  head "https://github.com/mfikes/planck.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "8e59e84a174f6da18a077ac34bd7af4c22b386987b794407ea57c1b6bfacac57" => :el_capitan
    sha256 "d7f0735c7749ed9543d4e1fff8d67739db6dedc89fbbd6bac9a48a517bc2ea72" => :yosemite
    sha256 "1c468166e15397e8a3b57f6b3b5780131be1ed688ce2380bf51d249394795785" => :mavericks
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
