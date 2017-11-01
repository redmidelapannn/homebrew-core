
class WildflyAsAT820 < Formula
  desc "Managed application runtime for building applications"
  homepage "http://wildfly.org/"
  url "https://download.jboss.org/wildfly/8.2.0.Final/wildfly-8.2.0.Final.tar.gz"
  sha256 "bf16e2be38fd1476b0e8a0b038f7d41d7ab525fc96c2a1077338814b7442728b"

  bottle do
    cellar :any_skip_relocation
    sha256 "77a3bd8c3e84c6c02e686d559b5b304de6ca8bdf650bd2bf51971a40819a19f2" => :high_sierra
    sha256 "77a3bd8c3e84c6c02e686d559b5b304de6ca8bdf650bd2bf51971a40819a19f2" => :sierra
    sha256 "77a3bd8c3e84c6c02e686d559b5b304de6ca8bdf650bd2bf51971a40819a19f2" => :el_capitan
  end

  depends_on :java => "1.7+"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install Dir["*"]
  end

  def caveats; <<-EOS.undent
    The home of WildFly Application Server 8 is:
      #{opt_libexec}
    You may want to add the following to your .bash_profile:
      export JBOSS_HOME=#{opt_libexec}
      export PATH=${PATH}:${JBOSS_HOME}/bin
    EOS
  end

  test do
    system "#{opt_libexec}/bin/standalone.sh --version | grep #{version}"
  end
end
