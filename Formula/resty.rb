class Resty < Formula
  desc "Command-line REST client that can be used in pipelines"
  homepage "https://github.com/micha/resty"
  url "https://github.com/micha/resty/archive/v3.0.tar.gz"
  sha256 "9ed8f50dcf70a765b3438840024b557470d7faae2f0c1957a011ebb6c94b9dd1"
  head "https://github.com/micha/resty.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d60984fcb7788604b11807750da2be7b8319f79d0755e52f27d126915a497c13" => :high_sierra
    sha256 "d7a85a8f2ef4bc3a8969bfd7b24c7a9d00e99ab9fdf4d5969ef8c9d24dad20b7" => :sierra
    sha256 "c78f2a072f6dd4fa3a385183308644b9fa4bc07d63be29689aa10eb3aa1d5f05" => :el_capitan
  end

  resource "JSON" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-2.94.tar.gz"
    sha256 "12271b5cee49943bbdde430eef58f1fe64ba6561980b22c69585e08fc977dc6d"
  end

  def install
    pkgshare.install "resty"

    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resource("JSON").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    bin.install "pp"
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])

    bin.install "pypp"
  end

  def caveats; <<~EOS
    To activate the resty, add the following at the end of your #{shell_profile}:
    source #{opt_pkgshare}/resty
    EOS
  end

  test do
    cmd = "zsh -c '. #{pkgshare}/resty && resty https://api.github.com' 2>&1"
    assert_equal "https://api.github.com*", shell_output(cmd).chomp
    json_pretty_pypp=<<~EOS
      {
          "a": 1
      }
    EOS
    json_pretty_pp=<<~EOS
      {
         "a" : 1
      }
    EOS
    assert_equal json_pretty_pypp, pipe_output("#{bin}/pypp", '{"a":1}', 0)
    assert_equal json_pretty_pp, pipe_output("#{bin}/pp", '{"a":1}', 0).chomp
  end
end
