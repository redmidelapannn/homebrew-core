# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2017.01.02/youtube-dl-2017.01.02.tar.gz"
  sha256 "140de01ea879cdc50bc34240802d5c10231baf448d7a664e6efeb9d5efb74d5b"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2276d32f7e1bcac4a6d4b327f79e6bdde0d662985c204d0b28173765096c9f82" => :sierra
    sha256 "a58b08bea8ed15537e5bc995a0ef786a960ed07ef14c3f9c994647b395ee86b9" => :el_capitan
    sha256 "a58b08bea8ed15537e5bc995a0ef786a960ed07ef14c3f9c994647b395ee86b9" => :yosemite
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
