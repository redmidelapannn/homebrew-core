class Unison < Formula
  desc "File synchronization tool for OSX"
  homepage "https://www.cis.upenn.edu/~bcpierce/unison/"
  url "https://www.seas.upenn.edu/~bcpierce/unison//download/releases/stable/unison-2.48.4.tar.gz"
  sha256 "30aa53cd671d673580104f04be3cf81ac1e20a2e8baaf7274498739d59e99de8"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "9f00ed7b21e8f283107697529df8f84649e8b92570937b0381e549b3934ccf48" => :el_capitan
    sha256 "218017bf7c754e6099b735f476b8613f6ac9b3b76ef75a70febfdfb559f6df4e" => :yosemite
    sha256 "a406926c03c577edbb59f8de37de5a9756407b9ab0998a50b10e57548277525a" => :mavericks
  end

  depends_on "ocaml" => :build

  def install
    ENV.j1
    ENV.delete "CFLAGS" # ocamlopt reads CFLAGS but doesn't understand common options
    ENV.delete "NAME" # https://github.com/Homebrew/homebrew/issues/28642
    system "make", "./mkProjectInfo"
    system "make", "UISTYLE=text"
    bin.install "unison"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unison -version")
  end
end
