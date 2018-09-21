class Mkvtomp4 < Formula
  desc "Convert mkv files to mp4"
  homepage "https://github.com/gavinbeatty/mkvtomp4/"
  url "https://github.com/gavinbeatty/mkvtomp4/archive/mkvtomp4-v1.3.tar.gz"
  sha256 "cc644b9c0947cf948c1b0f7bbf132514c6f809074ceed9edf6277a8a1b81c87a"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1f9301b4eec2b997f954f2f55c23bc3e6b426999cbee18776298aa989bdf266e" => :mojave
    sha256 "67c927e28aff704acfc64a246a3d18cb404524191f0896cc61e4f6e594715e99" => :high_sierra
    sha256 "67c927e28aff704acfc64a246a3d18cb404524191f0896cc61e4f6e594715e99" => :sierra
    sha256 "67c927e28aff704acfc64a246a3d18cb404524191f0896cc61e4f6e594715e99" => :el_capitan
  end

  depends_on "ffmpeg"
  depends_on "gpac"
  depends_on "mkvtoolnix"
  depends_on "python@2"

  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", lib+"python2.7/site-packages"

    system "make"
    system "python", "setup.py", "install", "--prefix=#{prefix}"

    bin.install "mkvtomp4.py" => "mkvtomp4"
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/mkvtomp4", "--help"
  end
end
