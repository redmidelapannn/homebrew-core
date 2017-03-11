class Clucene < Formula
  desc "C++ port of Lucene: high-performance, full-featured text search engine"
  homepage "https://clucene.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/clucene/clucene-core-unstable/2.3/clucene-core-2.3.3.4.tar.gz"
  sha256 "ddfdc433dd8ad31b5c5819cc4404a8d2127472a3b720d3e744e8c51d79732eab"
  head "https://git.code.sf.net/p/clucene/code.git"

  bottle do
    cellar :any
    rebuild 2
    sha256 "90557984c25def9e4d4e612f88bc1743663a2648b6e496db896da36c4b79e87e" => :sierra
    sha256 "e14cf77295195e77dd40a7f0d7542989c46a3ee64a71cd0ca02350b49f1124f1" => :el_capitan
    sha256 "324e7a72753266f4aeb313fe7197e7e82035ea2d423abb657923d5284b34cab0" => :yosemite
  end

  depends_on "cmake" => :build

  # Portability fixes for 10.9+
  # Upstream ticket: https://sourceforge.net/p/clucene/bugs/219/
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/ec8d133/clucene/patch-src-shared-CLucene-LuceneThreads.h.diff"
    sha256 "42cb23fa6bd66ca8ea1d83a57a650f71e0ad3d827f5d74837b70f7f72b03b490"
  end

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/ec8d133/clucene/patch-src-shared-CLucene-config-repl_tchar.h.diff"
    sha256 "b7dc735f431df409aac63dcfda9737726999eed4fdae494e9cbc1d3309e196ad"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end
end
