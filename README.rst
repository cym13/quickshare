Description
===========

QuickShare (qs) is a variant of the (now legacy) SimpleHTTPServer present in
python 2.x. It allows one to share quickly directories by opening a http
server. qs supports both python2 and python3.

You can define an upload rate limit to prevent the clients from using all
your bandwidth and it automatically searches a free port if the given or
default one is taken.

Why QuickShare?
===============

http://xkcd.com/949/

Sharing is fun, but it quickly becomes a pain when dealing with multiple
operating systems, platforms and unexperimented users. Nowadays, almost
everything has a web interface, why should'nt we use it?

Documentation
=============

::

    Usage: qs [-h] [-p PORT] [-r RATE] [--no-sf] [FILE]...

    Options:
        -h, --help       Print this help and exit.
        -p, --port PORT  Port on which the server is listenning.
                         Default is 8000
        -r, --rate RATE  Limit upload to RATE in ko/s.
                         Default is 0 meaning no limitation.
        --no-sf          Do not search a free port if the selected one is taken.
                         Otherwise, increase the port number until it finds one.
        --version        Print the current version

    Arguments:
        FILE             Files or directory to share.
                         Default is the current directory: `.'
                         If '-' is given, read from stdin.
                         If 'index.html' is found in the directory, it is served.

Dependencies
============

docopt  https://github.com/docopt/docopt or "pip install docopt"

Install
=======

The simplest is to use

::

    pip install qs

or, in this directory,

::

    python setup.py install

License
=======

This program is under the GPLv3 License.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.

Contact
=======

::

    Main developper: Cédric Picard
    Email:           cedric.picard@efrei.net
