class Pssh < Formula
  desc "Parallel versions of OpenSSH and related tools"
  homepage "https://code.google.com/archive/p/parallel-ssh/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/parallel-ssh/pssh-2.3.1.tar.gz"
  sha256 "539f8d8363b722712310f3296f189d1ae8c690898eca93627fc89a9cb311f6b4"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c129cc74a70666882a16ebea0a5a002123d690c0d4b9bb5abe77e8d8c5e26e4a" => :high_sierra
    sha256 "c129cc74a70666882a16ebea0a5a002123d690c0d4b9bb5abe77e8d8c5e26e4a" => :sierra
    sha256 "c129cc74a70666882a16ebea0a5a002123d690c0d4b9bb5abe77e8d8c5e26e4a" => :el_capitan
  end

  depends_on "python@2"

  conflicts_with "putty", :because => "both install `pscp` binaries"

  def install
    ENV["PYTHONPATH"] = lib/"python2.7/site-packages"

    system "python", "setup.py", "install", "--prefix=#{prefix}",
                                 "--install-data=#{share}"

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system bin/"pssh", "--version"
  end
end
