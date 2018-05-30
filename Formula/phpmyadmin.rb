class Phpmyadmin < Formula
  desc "Web interface for MySQL and MariaDB"
  homepage "https://www.phpmyadmin.net"
  url "https://files.phpmyadmin.net/phpMyAdmin/4.8.1/phpMyAdmin-4.8.1-all-languages.tar.gz"
  sha256 "4f7771e96a1637797e0dc710d36345d8327a612d8c08ac305018ef7185f2217d"

  bottle do
    cellar :any_skip_relocation
    sha256 "28181b5c2b4fd43ad2ad13ada89696ac84f423a195cb9f0de86bac5fed853d60" => :high_sierra
    sha256 "28181b5c2b4fd43ad2ad13ada89696ac84f423a195cb9f0de86bac5fed853d60" => :sierra
    sha256 "28181b5c2b4fd43ad2ad13ada89696ac84f423a195cb9f0de86bac5fed853d60" => :el_capitan
  end

  depends_on "php" => :test

  def install
    pkgshare.install Dir["*"]

    etc.install pkgshare+"config.sample.inc.php" => "phpmyadmin.config.inc.php"
    ln_s (etc+"phpmyadmin.config.inc.php"), (pkgshare+"config.inc.php")
  end

  def caveats; <<~EOS
    Note that this formula will NOT install mysql. It is not required since you
    may want to connect to a remote database server.

    To enable phpMyAdmin in Apache, add the following to httpd.conf and
    restart Apache:
        Alias /phpmyadmin #{HOMEBREW_PREFIX}/share/phpmyadmin
        <Directory #{HOMEBREW_PREFIX}/share/phpmyadmin/>
            Options Indexes FollowSymLinks MultiViews
            AllowOverride All
            <IfModule mod_authz_core.c>
                Require all granted
            </IfModule>
            <IfModule !mod_authz_core.c>
                Order allow,deny
                Allow from all
            </IfModule>
        </Directory>
    Then, open http://localhost/phpmyadmin

    More documentation : file://#{pkgshare}/doc/

    Configuration has been copied to #{etc}/phpmyadmin.config.inc.php
    Don't forget to:
      - change your secret blowfish
      - uncomment the configuration lines (pma, pmapass ...)

    EOS
  end

  test do
    Dir.chdir(pkgshare)
    system "php", pkgshare/"index.php"
  end
end
