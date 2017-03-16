class MysqlSandbox < Formula
  desc "Install one or more MySQL servers"
  homepage "https://mysqlsandbox.net"
  url "https://github.com/datacharmer/mysql-sandbox/archive/3.2.05.tar.gz"
  sha256 "ef500e0561c0ce397334eb5c8af8f1192034af6d2b006efdab3c70ada48a15e8"
  head "https://github.com/datacharmer/mysql-sandbox.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "de31898755527e7c7cfc26dd6ed4d0b959aa5821f1e947b37eb357c1ea1e9482" => :sierra
    sha256 "97ab124ebf938b86d325805951d8575c54ab22f9e11f94359e29c467abc9e801" => :el_capitan
    sha256 "1437a65b89a2a6c6126e8c13006e5b3930227c68d5c782f10fb7efa170dd0a16" => :yosemite
  end

  def install
    ENV["PERL_LIBDIR"] = libexec/"lib/perl5"
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5/site_perl"

    system "perl", "Makefile.PL", "PREFIX=#{libexec}"
    system "make", "test", "install"

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/msandbox", 1)
  end
end
