# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2017.01.25/youtube-dl-2017.01.25.tar.gz"
  sha256 "80c6d8c6d9b5412a4ad8547400450ce5d1029067cf5a137bb0abcc667a6c60e1"

  bottle do
    cellar :any_skip_relocation
    sha256 "a1dc500fc987d81f0ec6f1040a9fbd0dfd449eb9ce058c0c81886ff12de946b6" => :sierra
    sha256 "b393d9ee92a927cdaf2a7949813a3f7d131e1f9709cf16777799a0a3990f3002" => :el_capitan
    sha256 "a1dc500fc987d81f0ec6f1040a9fbd0dfd449eb9ce058c0c81886ff12de946b6" => :yosemite
  end

  head do
    url "https://github.com/rg3/youtube-dl.git"
    depends_on "pandoc" => :build
  end

  depends_on "rtmpdump" => :optional

  def install
    system "make", "PREFIX=#{prefix}"
    bin.install "youtube-dl"
    man1.install "youtube-dl.1"
    bash_completion.install "youtube-dl.bash-completion"
    zsh_completion.install "youtube-dl.zsh" => "_youtube-dl"
    fish_completion.install "youtube-dl.fish"
  end

  def caveats
    "To use post-processing options, `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system "#{bin}/youtube-dl", "--simulate", "https://www.youtube.com/watch?v=he2a4xK8ctk"
    system "#{bin}/youtube-dl", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=AEhULv4ruL4&list=PLZdCLR02grLrl5ie970A24kvti21hGiOf"
  end
end
