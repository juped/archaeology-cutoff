(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var TreeDispatcher, TreePersistence;

TreeDispatcher = require('../dispatcher/Dispatcher.coffee');

TreePersistence = require('../persistence/TreePersistence.coffee');

module.exports = {
  loadPath: function(path, body, kids) {
    return TreeDispatcher.handleServerAction({
      type: "path-load",
      path: path,
      body: body,
      kids: kids
    });
  },
  loadKids: function(path, kids) {
    return TreeDispatcher.handleServerAction({
      type: "kids-load",
      path: path,
      kids: kids
    });
  },
  loadSnip: function(path, kids) {
    return TreeDispatcher.handleServerAction({
      type: "snip-load",
      path: path,
      kids: kids
    });
  },
  getPath: function(path, query) {
    if (query == null) {
      return;
    }
    if (path.slice(-1) === "/") {
      path = path.slice(0, -1);
    }
    if (typeof query === 'string') {
      query = {
        body: {
          body: 'r',
          kids: {
            name: 't'
          }
        },
        kids: {
          kids: {
            name: 't',
            body: 'r'
          }
        },
        snip: {
          kids: {
            name: 't',
            snip: 'r',
            head: 'r',
            meta: 'j'
          }
        }
      }[query];
    }
    return TreePersistence.get(path, query, (function(_this) {
      return function(err, res) {
        var ref, ref1;
        switch (false) {
          case !((ref = query.kids) != null ? ref.snip : void 0):
            return _this.loadSnip(path, res.kids);
          case !((ref1 = query.kids) != null ? ref1.body : void 0):
            return _this.loadKids(path, res.kids);
          default:
            return _this.loadPath(path, res.body, res.kids);
        }
      };
    })(this));
  },
  setCurr: function(path) {
    return TreeDispatcher.handleViewAction({
      type: "set-curr",
      path: path
    });
  }
};


},{"../dispatcher/Dispatcher.coffee":11,"../persistence/TreePersistence.coffee":17}],2:[function(require,module,exports){
var BodyComponent, TreeActions, TreeStore, a, div, reactify, recl, ref,
  slice = [].slice;

BodyComponent = React.createFactory(require('./BodyComponent.coffee'));

reactify = React.createFactory(require('./Reactify.coffee'));

TreeStore = require('../stores/TreeStore.coffee');

TreeActions = require('../actions/TreeActions.coffee');

recl = React.createClass;

ref = React.DOM, div = ref.div, a = ref.a;

module.exports = recl({
  displayName: "Anchor",
  stateFromStore: function() {
    return {
      path: TreeStore.getCurr(),
      pare: TreeStore.getPare(),
      sibs: TreeStore.getSiblings(),
      snip: TreeStore.getSnip(),
      next: TreeStore.getNext(),
      prev: TreeStore.getPrev(),
      cont: TreeStore.getCont(),
      url: window.location.pathname
    };
  },
  toggleFocus: function(state) {
    return $(this.getDOMNode()).toggleClass('focus', state);
  },
  _click: function() {
    return this.toggleFocus();
  },
  _mouseOver: function() {
    return this.toggleFocus(true);
  },
  _mouseOut: function() {
    return this.toggleFocus(false);
  },
  _touchStart: function() {
    return this.ts = Number(Date.now());
  },
  _touchEnd: function() {
    var dt;
    return dt = this.ts - Number(Date.now());
  },
  setPath: function(href, hist) {
    var href_parts, next;
    href_parts = href.split("#");
    next = href_parts[0];
    if (next.substr(-1) === "/") {
      next = next.slice(0, -1);
    }
    href_parts[0] = next;
    if (hist !== false) {
      history.pushState({}, "", window.tree.basepath(href_parts.join("")));
    }
    if (next !== this.state.path) {
      React.unmountComponentAtNode($('#cont')[0]);
      TreeActions.setCurr(next);
      return React.render(BodyComponent({}, ""), $('#cont')[0]);
    }
  },
  goTo: function(path) {
    this.toggleFocus(false);
    $("html,body").animate({
      scrollTop: 0
    });
    return this.setPath(path);
  },
  checkURL: function() {
    if (this.state.url !== window.location.pathname) {
      return this.setPath(window.tree.fragpath(window.location.pathname), false);
    }
  },
  setTitle: function() {
    var path, title;
    title = $('#cont h1').first().text();
    if (title.length === 0) {
      path = this.state.path.split("/");
      title = path[path.length - 1];
    }
    return document.title = title + " - " + this.state.path;
  },
  checkUp: function() {
    var ref1, up;
    up = (ref1 = this.state.pare) != null ? ref1 : "/";
    if (up.slice(-1) === "/") {
      up = up.slice(0, -1);
    }
    if (this.state.cont[up] == null) {
      TreeActions.getPath(up, "body");
    }
    if (!TreeStore.gotSnip(up)) {
      return TreeActions.getPath(up, "snip");
    }
  },
  componentDidUpdate: function() {
    this.setTitle();
    return this.checkUp();
  },
  componentDidMount: function() {
    TreeStore.addChangeListener(this._onChangeStore);
    this.setTitle();
    this.checkUp();
    this.interval = setInterval(this.checkURL, 100);
    $('body').on('keyup', (function(_this) {
      return function(e) {
        switch (e.keyCode) {
          case 37:
            return _this.goTo(_this.state.prev);
          case 39:
            return _this.goTo(_this.state.next);
        }
      };
    })(this));
    return $('body').on('click', 'a', (function(_this) {
      return function(e) {
        var href;
        href = $(e.target).closest('a').attr('href');
        if (href[0] === "/") {
          e.preventDefault();
          e.stopPropagation();
          return _this.goTo(window.tree.fragpath(href));
        }
      };
    })(this));
  },
  componentWillUnmount: function() {
    clearInterval(this.interval);
    return $('body').off('click', 'a');
  },
  getInitialState: function() {
    return this.stateFromStore();
  },
  _onChangeStore: function() {
    return this.setState(this.stateFromStore());
  },
  renderArrow: function(name, path) {
    var href;
    href = window.tree.basepath(path);
    return a({
      href: href,
      key: "arow-" + name,
      className: "arow-" + name
    }, "");
  },
  toText: function(elem) {
    return $(React.renderToStaticMarkup(reactify({
      manx: elem
    }))).text();
  },
  renderParts: function() {
    var _sibs, ci, curr, j, k, ref1, style, up;
    return [
      this.state.pare ? _.filter([
        div({
          id: "up",
          key: "up"
        }, this.renderArrow("up", this.state.pare)), this.state.prev || this.state.next ? div({
          id: "sides",
          key: "sides"
        }, _.filter([this.state.prev ? this.renderArrow("prev", this.state.prev) : void 0, this.state.next ? this.renderArrow("next", this.state.next) : void 0])) : void 0
      ]) : void 0, _.keys(this.state.sibs).length > 0 ? ((ref1 = this.state.path.split("/"), up = 2 <= ref1.length ? slice.call(ref1, 0, j = ref1.length - 1) : (j = 0, []), curr = ref1[j++], ref1), up = up.join("/"), ci = 0, k = 0, _sibs = _(this.state.sibs).keys().sort().map((function(_this) {
        return function(i) {
          var className, head, href, path, ref2, snip;
          if (curr === i) {
            className = "active";
            ci = k;
          }
          if (className == null) {
            className = "";
          }
          k++;
          path = up + "/" + i;
          href = window.tree.basepath(path);
          snip = _this.state.snip[path];
          head = snip != null ? (ref2 = snip.meta) != null ? ref2.title : void 0 : void 0;
          if (snip != null ? snip.head : void 0) {
            if (head == null) {
              head = _this.toText(snip != null ? snip.head : void 0);
            }
          }
          head || (head = i);
          return div({
            className: className,
            key: i
          }, a({
            href: href,
            onClick: _this._click
          }, head));
        };
      })(this)), style = {
        marginTop: (-24 * ci) + "px"
      }, div({
        key: "sibs",
        id: "sibs",
        style: style
      }, _sibs)) : void 0
    ];
  },
  render: function() {
    var obj;
    obj = {
      onMouseOver: this._mouseOver,
      onMouseOut: this._mouseOut,
      onClick: this._click,
      onTouchStart: this._touchStart,
      onTouchEnd: this._touchEnd
    };
    if (_.keys(window).indexOf("ontouchstart") !== -1) {
      delete obj.onMouseOver;
      delete obj.onMouseOut;
    }
    return div(obj, _.filter(this.renderParts()));
  }
});


},{"../actions/TreeActions.coffee":1,"../stores/TreeStore.coffee":18,"./BodyComponent.coffee":4,"./Reactify.coffee":9}],3:[function(require,module,exports){
var TreeActions, TreeStore, code, div, load, recl, ref, span;

load = React.createFactory(require('./LoadComponent.coffee'));

TreeStore = require('../stores/TreeStore.coffee');

TreeActions = require('../actions/TreeActions.coffee');

recl = React.createClass;

ref = React.DOM, div = ref.div, span = ref.span, code = ref.code;

module.exports = function(queries, Child) {
  return recl({
    displayName: "Async",
    stateFromStore: function() {
      var path, ref1;
      path = (ref1 = this.props.dataPath) != null ? ref1 : TreeStore.getCurr();
      return {
        path: path,
        got: TreeStore.fulfill(path, queries)
      };
    },
    componentDidMount: function() {
      TreeStore.addChangeListener(this._onChangeStore);
      return this.checkPath();
    },
    componentWillUnmount: function() {
      return TreeStore.removeChangeListener(this._onChangeStore);
    },
    componentDidUpdate: function(_props, _state) {
      return this.checkPath();
    },
    filterQueries: function() {
      return this.filterWith(this.state.got, queries);
    },
    filterWith: function(have, _queries) {
      var k, kid, ref1, request;
      if (have == null) {
        return _queries;
      }
      request = {};
      for (k in _queries) {
        if (have[k] == null) {
          request[k] = _queries[k];
        }
      }
      if ((_queries.kids != null) && (have.kids != null)) {
        if (_.isEmpty(have.kids)) {
          request.kids = _queries.kids;
        } else {
          request.kids = {};
          ref1 = have.kids;
          for (k in ref1) {
            kid = ref1[k];
            _.merge(request.kids, this.filterWith(kid, _queries.kids));
          }
          if (_.isEmpty(request.kids)) {
            delete request.kids;
          }
        }
      }
      if (!_.isEmpty(request)) {
        return request;
      }
    },
    checkPath: function() {
      return TreeActions.getPath(this.state.path, this.filterQueries());
    },
    getInitialState: function() {
      return this.stateFromStore();
    },
    _onChangeStore: function() {
      return this.setState(this.stateFromStore());
    },
    render: function() {
      return div({}, this.filterQueries() != null ? div({
        className: "loading"
      }, load({}, "")) : React.createElement(Child, _.merge(this.props, this.state.got), this.props.children));
    }
  });
};


},{"../actions/TreeActions.coffee":1,"../stores/TreeStore.coffee":18,"./LoadComponent.coffee":8}],4:[function(require,module,exports){
var div, query, reactify, recl;

reactify = React.createFactory(require('./Reactify.coffee'));

query = require('./Async.coffee');

recl = React.createClass;

div = React.DOM.div;

module.exports = query({
  body: 'r',
  path: 't'
}, recl({
  displayName: "Body",
  render: function() {
    return div({}, div({
      id: 'body',
      key: "body" + this.props.path
    }, reactify({
      manx: this.props.body
    })));
  }
}));


},{"./Async.coffee":3,"./Reactify.coffee":9}],5:[function(require,module,exports){
var div, recl, ref, textarea;

recl = React.createClass;

ref = React.DOM, div = ref.div, textarea = ref.textarea;

module.exports = recl({
  render: function() {
    return div({}, textarea({
      ref: 'ed',
      value: this.props.value
    }));
  },
  componentDidMount: function() {
    return CodeMirror.fromTextArea(this.refs.ed.getDOMNode(), {
      readOnly: true,
      lineNumbers: true
    });
  }
});


},{}],6:[function(require,module,exports){
var a, div, hr, li, query, reactify, recl, ref, ul;

reactify = function(manx) {
  return React.createElement(window.tree.reactify, {
    manx: manx
  });
};

query = require('./Async.coffee');

recl = React.createClass;

ref = React.DOM, div = ref.div, a = ref.a, ul = ref.ul, li = ref.li, hr = ref.hr;

module.exports = query({
  kids: {
    body: 'r'
  }
}, recl({
  displayName: "Kids",
  render: function() {
    var v;
    return div({
      className: "kids"
    }, (function() {
      var i, len, ref1, results;
      ref1 = _.keys(this.props.kids).sort();
      results = [];
      for (i = 0, len = ref1.length; i < len; i++) {
        v = ref1[i];
        results.push([
          div({
            key: v
          }, reactify(this.props.kids[v].body)), hr({}, "")
        ]);
      }
      return results;
    }).call(this));
  }
}));


},{"./Async.coffee":3}],7:[function(require,module,exports){
var a, clas, div, h1, li, query, reactify, recl, ref, ul,
  slice = [].slice;

clas = require('classnames');

reactify = function(manx) {
  return React.createElement(window.tree.reactify, {
    manx: manx
  });
};

query = require('./Async.coffee');

recl = React.createClass;

ref = React.DOM, div = ref.div, a = ref.a, ul = ref.ul, li = ref.li, h1 = ref.h1;

module.exports = query({
  path: 't',
  kids: {
    snip: 'r',
    head: 'r',
    meta: 'j'
  }
}, recl({
  displayName: "List",
  render: function() {
    var k;
    k = clas({
      list: true,
      posts: this.props.dataType === 'post',
      "default": this.props['data-source'] === 'default'
    });
    return ul({
      className: k
    }, this.renderList());
  },
  renderList: function() {
    var _keys, elem, head, href, i, item, len, path, ref1, ref2, results;
    _keys = _.keys(this.props.kids).sort();
    if (this.props.dataType === 'post') {
      _keys = _keys.reverse();
    }
    results = [];
    for (i = 0, len = _keys.length; i < len; i++) {
      item = _keys[i];
      path = this.props.path + "/" + item;
      elem = this.props.kids[item];
      href = window.tree.basepath(path);
      results.push(li({
        className: (ref1 = this.props.dataType) != null ? ref1 : ""
      }, a({
        href: href,
        className: clas({
          preview: this.props.dataPreview != null
        })
      }, this.props.dataPreview == null ? h1({}, item) : this.props.dataType === 'post' ? (head = ((ref2 = elem.meta) != null ? ref2.title : void 0) ? {
        gn: 'h1',
        c: [elem.meta.title]
      } : elem.head, reactify({
        gn: 'div',
        c: [head].concat(slice.call(elem.snip.c.slice(0, 2)))
      })) : this.props.titlesOnly != null ? reactify(elem.head) : [reactify(elem.head), reactify(elem.snip)])));
    }
    return results;
  }
}));


},{"./Async.coffee":3,"classnames":13}],8:[function(require,module,exports){
var div, input, recl, ref, textarea;

recl = React.createClass;

ref = React.DOM, div = ref.div, input = ref.input, textarea = ref.textarea;

module.exports = recl({
  displayName: "Load",
  getInitialState: function() {
    return {
      anim: 0
    };
  },
  componentDidMount: function() {
    return this.interval = setInterval(this.setAnim, 100);
  },
  componentWillUnmount: function() {
    return clearInterval(this.interval);
  },
  setAnim: function() {
    var anim;
    anim = this.state.anim + 1;
    if (anim > 3) {
      anim = 0;
    }
    return this.setState({
      anim: anim
    });
  },
  render: function() {
    return div({
      className: "spin state-" + this.state.anim
    }, "");
  }
});


},{}],9:[function(require,module,exports){
var codemirror, components, div, kids, list, load, lost, recl, ref, span, toc;

recl = React.createClass;

ref = React.DOM, div = ref.div, span = ref.span;

load = React.createFactory(require('./LoadComponent.coffee'));

codemirror = require('./CodeMirror.coffee');

list = require('./ListComponent.coffee');

kids = require('./KidsComponent.coffee');

toc = require('./TocComponent.coffee');

lost = recl({
  render: function() {
    return div({}, "lost");
  }
});

components = {
  kids: kids,
  list: list,
  lost: lost,
  toc: toc,
  codemirror: codemirror
};

module.exports = recl({
  displayName: "Virtual",
  render: function() {
    return this.walk(this.props.manx);
  },
  walk: function(obj, key) {
    var ref1;
    switch (false) {
      case !(obj == null):
        return span({
          className: "loading"
        }, load({}, ""));
      case typeof obj !== "string":
        return obj;
      case obj.gn == null:
        return React.createElement((ref1 = components[obj.gn]) != null ? ref1 : obj.gn, $.extend({
          key: key
        }, obj.ga), obj.c.map(this.walk));
      default:
        throw "Bad react-json " + (JSON.stringify(obj));
    }
  }
});


},{"./CodeMirror.coffee":5,"./KidsComponent.coffee":6,"./ListComponent.coffee":7,"./LoadComponent.coffee":8,"./TocComponent.coffee":10}],10:[function(require,module,exports){
var TreeActions, TreeStore, a, clas, div, li, load, reactify, recl, ref, ul;

clas = require('classnames');

TreeStore = require('../stores/TreeStore.coffee');

TreeActions = require('../actions/TreeActions.coffee');

load = React.createFactory(require('./LoadComponent.coffee'));

reactify = function(manx) {
  return React.createElement(window.tree.reactify, {
    manx: manx
  });
};

recl = React.createClass;

ref = [React.DOM.div, React.DOM.a, React.DOM.ul, React.DOM.li, React.DOM.h1], div = ref[0], a = ref[1], ul = ref[2], li = ref[3];

module.exports = recl({
  hash: null,
  displayName: "TableofContents",
  stateFromStore: function() {
    var path, ref1, state;
    path = (ref1 = this.props.dataPath) != null ? ref1 : TreeStore.getCurr();
    state = {
      path: path,
      snip: TreeStore.getSnip(),
      tree: TreeStore.getTree(path.split("/")),
      tocs: this.compute()
    };
    return state;
  },
  _onChangeStore: function() {
    return this.setState(this.stateFromStore());
  },
  _click: function(e) {
    console.log('click');
    return document.location.hash = this.urlsafe($(e.target).text());
  },
  urlsafe: function(str) {
    return str.toLowerCase().replace(/\ /g, "-");
  },
  componentDidMount: function() {
    this.int = setInterval(this.checkHash, 100);
    return this.setState(this.stateFromStore());
  },
  checkHash: function() {
    var hash, k, ref1, results, v;
    if ((document.location.hash != null) && document.location.hash !== this.hash) {
      hash = document.location.hash.slice(1);
      ref1 = this.state.tocs;
      results = [];
      for (k in ref1) {
        v = ref1[k];
        if (hash === this.urlsafe(v.t)) {
          this.hash = document.location.hash;
          $(window).scrollTop(v.e.offset().top);
          break;
        } else {
          results.push(void 0);
        }
      }
      return results;
    }
  },
  componentWillUnmount: function() {
    TreeStore.removeChangeListener(this._onChangeStore);
    return clearInterval(this.int);
  },
  getInitialState: function() {
    return this.stateFromStore();
  },
  gotPath: function() {
    return TreeStore.gotSnip(this.state.path);
  },
  compute: function() {
    var $h, $headers, c, h, j, len;
    $headers = $('#toc h1, #toc h2, #toc h3, #toc h4');
    c = [];
    if ($headers.length === 0) {
      return c;
    }
    for (j = 0, len = $headers.length; j < len; j++) {
      h = $headers[j];
      $h = $(h);
      c.push({
        h: h.tagName.toLowerCase(),
        t: $h.text(),
        e: $h
      });
    }
    return c;
  },
  render: function() {
    var onClick;
    onClick = this._click;
    return div({
      className: 'toc'
    }, this.state.tocs.map(function(i) {
      return React.DOM[i.h]({
        onClick: onClick
      }, i.t);
    }));
  }
});


},{"../actions/TreeActions.coffee":1,"../stores/TreeStore.coffee":18,"./LoadComponent.coffee":8,"classnames":13}],11:[function(require,module,exports){
var Dispatcher;

Dispatcher = require('flux').Dispatcher;

module.exports = _.extend(new Dispatcher(), {
  handleServerAction: function(action) {
    return this.dispatch({
      source: 'server',
      action: action
    });
  },
  handleViewAction: function(action) {
    return this.dispatch({
      source: 'view',
      action: action
    });
  }
});


},{"flux":14}],12:[function(require,module,exports){
var rend;

rend = React.render;

$(function() {
  var $body, TreeActions, TreePersistence, body, checkMove, checkScroll, frag, head, po, setSo, so;
  $body = $('body');
  React.initializeTouchEvents(true);
  head = React.createFactory(require('./components/AnchorComponent.coffee'));
  body = React.createFactory(require('./components/BodyComponent.coffee'));
  window.tree.reactify = require('./components/Reactify.coffee');
  window.tree._basepath = window.urb.util.basepath("/");
  window.tree._basepath += (window.location.pathname.replace(window.tree._basepath, "")).split("/")[0];
  window.tree.basepath = function(path) {
    var _path;
    if (path[0] !== "/") {
      path = "/" + path;
    }
    _path = window.tree._basepath + path;
    if (_path.slice(-1) === "/") {
      _path = _path.slice(0, -1);
    }
    return _path;
  };
  window.tree.fragpath = function(path) {
    return path.replace(window.tree._basepath, "");
  };
  TreeActions = require('./actions/TreeActions.coffee');
  TreePersistence = require('./persistence/TreePersistence.coffee');
  frag = window.tree.fragpath(window.location.pathname);
  TreeActions.setCurr(frag);
  TreeActions.loadPath(frag, window.tree.body, window.tree.kids);
  rend(head({}, ""), $('#nav')[0]);
  rend(body({}, ""), $('#cont')[0]);
  checkScroll = function() {
    if ($(window).scrollTop() > 20) {
      return $('#nav').addClass('scrolling');
    } else {
      return $('#nav').removeClass('scrolling');
    }
  };
  setInterval(checkScroll, 500);
  po = {};
  po.cm = null;
  po.lm = null;
  po.cs = $(window).scrollTop();
  po.ls = $(window).scrollTop();
  $(document).mousemove(function(e) {
    return po.cm = {
      x: e.pageX,
      y: e.pageY
    };
  });
  checkMove = function() {
    var ds, dx, dy;
    if (po.lm !== null && po.cm !== null) {
      po.cs = $(window).scrollTop();
      ds = Math.abs(po.cs - po.ls);
      dx = Math.abs(po.cm.x - po.lm.x);
      dy = Math.abs(po.cm.y - po.lm.y);
      $('#nav').toggleClass('moving', dx > 20 || dy > 20);
    }
    po.lm = po.cm;
    return po.ls = po.cs;
  };
  setInterval(checkMove, 200);
  so = {};
  so.ls = $(window).scrollTop();
  so.cs = $(window).scrollTop();
  so.w = null;
  so.$n = $('#nav');
  so.$d = $('#nav > div');
  so.nh = $('#nav').outerHeight(true);
  setSo = function() {
    so.w = $(window).width();
    return so.$n = $('#nav');
  };
  setInterval(setSo, 200);
  $(window).on('resize', function(e) {
    if (so.w > 1170) {
      return so.$n.removeClass('m-up m-down m-fixed');
    }
  });
  return $(window).on('scroll', function(e) {
    var dy, sto, top;
    so.cs = $(window).scrollTop();
    if (so.w > 1170) {
      so.$n.removeClass('m-up m-down m-fixed');
    }
    if (so.w < 1170) {
      dy = so.ls - so.cs;
      so.$d.removeClass('focus');
      if (so.cs <= 0) {
        so.$n.removeClass('m-up');
        so.$n.addClass('m-down m-fixed');
        return;
      }
      if (so.$n.hasClass('m-fixed' && so.w < 1024)) {
        so.$n.css({
          left: -1 * $(window).scrollLeft()
        });
      }
      if (dy > 0) {
        if (!so.$n.hasClass('m-down')) {
          so.$n.removeClass('m-up').addClass('m-down');
          top = so.cs - so.nh;
          if (top < 0) {
            top = 0;
          }
          so.$n.offset({
            top: top
          });
        }
        if (so.$n.hasClass('m-down') && !so.$n.hasClass('m-fixed') && so.$n.offset().top >= so.cs) {
          so.$n.addClass('m-fixed');
          so.$n.attr({
            style: ''
          });
        }
      }
      if (dy < 0) {
        if (!so.$n.hasClass('m-up')) {
          so.$n.removeClass('m-down m-fixed').addClass('m-up');
          so.$n.attr({
            style: ''
          });
          top = so.cs;
          sto = so.$n.offset().top;
          if (top < 0) {
            top = 0;
          }
          if (top > sto && top < sto + so.nh) {
            top = sto;
          }
          so.$n.offset({
            top: top
          });
        }
      }
    }
    return so.ls = so.cs;
  });
});


},{"./actions/TreeActions.coffee":1,"./components/AnchorComponent.coffee":2,"./components/BodyComponent.coffee":4,"./components/Reactify.coffee":9,"./persistence/TreePersistence.coffee":17}],13:[function(require,module,exports){
/*!
  Copyright (c) 2015 Jed Watson.
  Licensed under the MIT License (MIT), see
  http://jedwatson.github.io/classnames
*/

(function () {
	'use strict';

	function classNames () {

		var classes = '';

		for (var i = 0; i < arguments.length; i++) {
			var arg = arguments[i];
			if (!arg) continue;

			var argType = typeof arg;

			if ('string' === argType || 'number' === argType) {
				classes += ' ' + arg;

			} else if (Array.isArray(arg)) {
				classes += ' ' + classNames.apply(null, arg);

			} else if ('object' === argType) {
				for (var key in arg) {
					if (arg.hasOwnProperty(key) && arg[key]) {
						classes += ' ' + key;
					}
				}
			}
		}

		return classes.substr(1);
	}

	if (typeof module !== 'undefined' && module.exports) {
		module.exports = classNames;
	} else if (typeof define === 'function' && typeof define.amd === 'object' && define.amd){
		// AMD. Register as an anonymous module.
		define(function () {
			return classNames;
		});
	} else {
		window.classNames = classNames;
	}

}());

},{}],14:[function(require,module,exports){
/**
 * Copyright (c) 2014-2015, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

module.exports.Dispatcher = require('./lib/Dispatcher')

},{"./lib/Dispatcher":15}],15:[function(require,module,exports){
/*
 * Copyright (c) 2014, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 *
 * @providesModule Dispatcher
 * @typechecks
 */

"use strict";

var invariant = require('./invariant');

var _lastID = 1;
var _prefix = 'ID_';

/**
 * Dispatcher is used to broadcast payloads to registered callbacks. This is
 * different from generic pub-sub systems in two ways:
 *
 *   1) Callbacks are not subscribed to particular events. Every payload is
 *      dispatched to every registered callback.
 *   2) Callbacks can be deferred in whole or part until other callbacks have
 *      been executed.
 *
 * For example, consider this hypothetical flight destination form, which
 * selects a default city when a country is selected:
 *
 *   var flightDispatcher = new Dispatcher();
 *
 *   // Keeps track of which country is selected
 *   var CountryStore = {country: null};
 *
 *   // Keeps track of which city is selected
 *   var CityStore = {city: null};
 *
 *   // Keeps track of the base flight price of the selected city
 *   var FlightPriceStore = {price: null}
 *
 * When a user changes the selected city, we dispatch the payload:
 *
 *   flightDispatcher.dispatch({
 *     actionType: 'city-update',
 *     selectedCity: 'paris'
 *   });
 *
 * This payload is digested by `CityStore`:
 *
 *   flightDispatcher.register(function(payload) {
 *     if (payload.actionType === 'city-update') {
 *       CityStore.city = payload.selectedCity;
 *     }
 *   });
 *
 * When the user selects a country, we dispatch the payload:
 *
 *   flightDispatcher.dispatch({
 *     actionType: 'country-update',
 *     selectedCountry: 'australia'
 *   });
 *
 * This payload is digested by both stores:
 *
 *    CountryStore.dispatchToken = flightDispatcher.register(function(payload) {
 *     if (payload.actionType === 'country-update') {
 *       CountryStore.country = payload.selectedCountry;
 *     }
 *   });
 *
 * When the callback to update `CountryStore` is registered, we save a reference
 * to the returned token. Using this token with `waitFor()`, we can guarantee
 * that `CountryStore` is updated before the callback that updates `CityStore`
 * needs to query its data.
 *
 *   CityStore.dispatchToken = flightDispatcher.register(function(payload) {
 *     if (payload.actionType === 'country-update') {
 *       // `CountryStore.country` may not be updated.
 *       flightDispatcher.waitFor([CountryStore.dispatchToken]);
 *       // `CountryStore.country` is now guaranteed to be updated.
 *
 *       // Select the default city for the new country
 *       CityStore.city = getDefaultCityForCountry(CountryStore.country);
 *     }
 *   });
 *
 * The usage of `waitFor()` can be chained, for example:
 *
 *   FlightPriceStore.dispatchToken =
 *     flightDispatcher.register(function(payload) {
 *       switch (payload.actionType) {
 *         case 'country-update':
 *           flightDispatcher.waitFor([CityStore.dispatchToken]);
 *           FlightPriceStore.price =
 *             getFlightPriceStore(CountryStore.country, CityStore.city);
 *           break;
 *
 *         case 'city-update':
 *           FlightPriceStore.price =
 *             FlightPriceStore(CountryStore.country, CityStore.city);
 *           break;
 *     }
 *   });
 *
 * The `country-update` payload will be guaranteed to invoke the stores'
 * registered callbacks in order: `CountryStore`, `CityStore`, then
 * `FlightPriceStore`.
 */

  function Dispatcher() {
    this.$Dispatcher_callbacks = {};
    this.$Dispatcher_isPending = {};
    this.$Dispatcher_isHandled = {};
    this.$Dispatcher_isDispatching = false;
    this.$Dispatcher_pendingPayload = null;
  }

  /**
   * Registers a callback to be invoked with every dispatched payload. Returns
   * a token that can be used with `waitFor()`.
   *
   * @param {function} callback
   * @return {string}
   */
  Dispatcher.prototype.register=function(callback) {
    var id = _prefix + _lastID++;
    this.$Dispatcher_callbacks[id] = callback;
    return id;
  };

  /**
   * Removes a callback based on its token.
   *
   * @param {string} id
   */
  Dispatcher.prototype.unregister=function(id) {
    invariant(
      this.$Dispatcher_callbacks[id],
      'Dispatcher.unregister(...): `%s` does not map to a registered callback.',
      id
    );
    delete this.$Dispatcher_callbacks[id];
  };

  /**
   * Waits for the callbacks specified to be invoked before continuing execution
   * of the current callback. This method should only be used by a callback in
   * response to a dispatched payload.
   *
   * @param {array<string>} ids
   */
  Dispatcher.prototype.waitFor=function(ids) {
    invariant(
      this.$Dispatcher_isDispatching,
      'Dispatcher.waitFor(...): Must be invoked while dispatching.'
    );
    for (var ii = 0; ii < ids.length; ii++) {
      var id = ids[ii];
      if (this.$Dispatcher_isPending[id]) {
        invariant(
          this.$Dispatcher_isHandled[id],
          'Dispatcher.waitFor(...): Circular dependency detected while ' +
          'waiting for `%s`.',
          id
        );
        continue;
      }
      invariant(
        this.$Dispatcher_callbacks[id],
        'Dispatcher.waitFor(...): `%s` does not map to a registered callback.',
        id
      );
      this.$Dispatcher_invokeCallback(id);
    }
  };

  /**
   * Dispatches a payload to all registered callbacks.
   *
   * @param {object} payload
   */
  Dispatcher.prototype.dispatch=function(payload) {
    invariant(
      !this.$Dispatcher_isDispatching,
      'Dispatch.dispatch(...): Cannot dispatch in the middle of a dispatch.'
    );
    this.$Dispatcher_startDispatching(payload);
    try {
      for (var id in this.$Dispatcher_callbacks) {
        if (this.$Dispatcher_isPending[id]) {
          continue;
        }
        this.$Dispatcher_invokeCallback(id);
      }
    } finally {
      this.$Dispatcher_stopDispatching();
    }
  };

  /**
   * Is this Dispatcher currently dispatching.
   *
   * @return {boolean}
   */
  Dispatcher.prototype.isDispatching=function() {
    return this.$Dispatcher_isDispatching;
  };

  /**
   * Call the callback stored with the given id. Also do some internal
   * bookkeeping.
   *
   * @param {string} id
   * @internal
   */
  Dispatcher.prototype.$Dispatcher_invokeCallback=function(id) {
    this.$Dispatcher_isPending[id] = true;
    this.$Dispatcher_callbacks[id](this.$Dispatcher_pendingPayload);
    this.$Dispatcher_isHandled[id] = true;
  };

  /**
   * Set up bookkeeping needed when dispatching.
   *
   * @param {object} payload
   * @internal
   */
  Dispatcher.prototype.$Dispatcher_startDispatching=function(payload) {
    for (var id in this.$Dispatcher_callbacks) {
      this.$Dispatcher_isPending[id] = false;
      this.$Dispatcher_isHandled[id] = false;
    }
    this.$Dispatcher_pendingPayload = payload;
    this.$Dispatcher_isDispatching = true;
  };

  /**
   * Clear bookkeeping used for dispatching.
   *
   * @internal
   */
  Dispatcher.prototype.$Dispatcher_stopDispatching=function() {
    this.$Dispatcher_pendingPayload = null;
    this.$Dispatcher_isDispatching = false;
  };


module.exports = Dispatcher;

},{"./invariant":16}],16:[function(require,module,exports){
/**
 * Copyright (c) 2014, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 *
 * @providesModule invariant
 */

"use strict";

/**
 * Use invariant() to assert state which your program assumes to be true.
 *
 * Provide sprintf-style format (only %s is supported) and arguments
 * to provide information about what broke and what you were
 * expecting.
 *
 * The invariant message will be stripped in production, but the invariant
 * will remain to ensure logic does not differ in production.
 */

var invariant = function(condition, format, a, b, c, d, e, f) {
  if (false) {
    if (format === undefined) {
      throw new Error('invariant requires an error message argument');
    }
  }

  if (!condition) {
    var error;
    if (format === undefined) {
      error = new Error(
        'Minified exception occurred; use the non-minified dev environment ' +
        'for the full error message and additional helpful warnings.'
      );
    } else {
      var args = [a, b, c, d, e, f];
      var argIndex = 0;
      error = new Error(
        'Invariant Violation: ' +
        format.replace(/%s/g, function() { return args[argIndex++]; })
      );
    }

    error.framesToPop = 1; // we don't care about invariant's own frame
    throw error;
  }
};

module.exports = invariant;

},{}],17:[function(require,module,exports){
module.exports = {
  get: function(path, query, cb) {
    var url;
    if (query == null) {
      query = "no-query";
    }
    url = (window.tree.basepath(path)) + ".json?q=" + (this.encode(query));
    return $.get(url, {}, function(data) {
      if (cb) {
        return cb(null, data);
      }
    });
  },
  encode: function(obj) {
    var _encode, delim;
    delim = function(n) {
      return ('_'.repeat(n)) || '.';
    };
    _encode = function(obj) {
      var _dep, dep, k, res, sub, v;
      if (typeof obj !== 'object') {
        return [0, obj];
      }
      dep = 0;
      sub = (function() {
        var ref, results;
        results = [];
        for (k in obj) {
          v = obj[k];
          ref = _encode(v), _dep = ref[0], res = ref[1];
          if (_dep > dep) {
            dep = _dep;
          }
          if (res != null) {
            results.push(k + (delim(_dep)) + res);
          } else {
            results.push(void 0);
          }
        }
        return results;
      })();
      dep++;
      return [dep, sub.join(delim(dep))];
    };
    return (_encode(obj))[1];
  }
};


},{}],18:[function(require,module,exports){
var EventEmitter, MessageDispatcher, TreeStore, _cont, _curr, _got_snip, _snip, _tree, clog;

EventEmitter = require('events').EventEmitter;

MessageDispatcher = require('../dispatcher/Dispatcher.coffee');

clog = console.log;

_tree = {};

_cont = {};

_snip = {};

_got_snip = {};

_curr = "";

TreeStore = _.extend(EventEmitter.prototype, {
  addChangeListener: function(cb) {
    return this.on('change', cb);
  },
  removeChangeListener: function(cb) {
    return this.removeListener("change", cb);
  },
  emitChange: function() {
    return this.emit('change');
  },
  pathToArr: function(_path) {
    return _path.split("/");
  },
  filterQuery: function(query) {
    return this.filterWith(this.fulfill(_curr, query), query);
  },
  filterWith: function(have, query) {
    var _query, k, kid, ref;
    if (have == null) {
      return query;
    }
    _query = {};
    for (k in query) {
      if (have[k] == null) {
        _query[k] = query[k];
      }
    }
    if ((query.kids != null) && (have.kids != null)) {
      if (_.isEmpty(have.kids)) {
        _query.kids = query.kids;
      } else {
        _query.kids = {};
        ref = have.kids;
        for (k in ref) {
          kid = ref[k];
          _.merge(_query.kids, this.filterWith(kid, query.kids));
        }
        if (_.isEmpty(_query.kids)) {
          delete _query.kids;
        }
      }
    }
    if (!_.isEmpty(_query)) {
      return _query;
    }
  },
  fulfill: function(path, query) {
    var data, i, k, len, ref, ref1, ref2, ref3;
    data = this.fulfillLocal(path, query);
    if (query.body) {
      data.body = _cont[path];
    }
    if (query.head) {
      data.head = (ref = _snip[path]) != null ? ref.head : void 0;
    }
    if (query.snip) {
      data.snip = (ref1 = _snip[path]) != null ? ref1.body : void 0;
    }
    if (query.meta) {
      data.meta = (ref2 = _snip[path]) != null ? ref2.meta : void 0;
    }
    if (query.kids) {
      data.kids = {};
      ref3 = this.getKids(path);
      for (i = 0, len = ref3.length; i < len; i++) {
        k = ref3[i];
        data.kids[k] = this.fulfill(path + "/" + k, query.kids);
      }
    }
    if (!_.isEmpty(data)) {
      return data;
    }
  },
  fulfillLocal: function(path, query) {
    var data;
    data = {};
    if (query.path) {
      data.path = path;
    }
    if (query.name) {
      data.name = path.split("/").pop();
    }
    if (query.sein) {
      data.sein = TreeStore.getPare(path);
    }
    if (query.sibs) {
      data.sibs = TreeStore.getSiblings(path);
    }
    if (query.next) {
      data.next = TreeStore.getNext(path);
    }
    if (query.prev) {
      data.prev = TreeStore.getPrev(path);
    }
    return data;
  },
  getTree: function(_path) {
    var i, len, sub, tree;
    tree = _tree;
    for (i = 0, len = _path.length; i < len; i++) {
      sub = _path[i];
      tree = tree[sub];
      if (tree == null) {
        return null;
      }
    }
    return tree;
  },
  setCurr: function(path) {
    return _curr = path;
  },
  getCurr: function() {
    return _curr;
  },
  getCont: function() {
    return _cont;
  },
  mergePathToTree: function(path, kids) {
    var i, j, len, len1, ref, ref1, ref2, sub, tree, x;
    tree = _tree;
    ref = this.pathToArr(path);
    for (i = 0, len = ref.length; i < len; i++) {
      sub = ref[i];
      tree[sub] = (ref1 = tree[sub]) != null ? ref1 : {};
      tree = tree[sub];
    }
    for (j = 0, len1 = kids.length; j < len1; j++) {
      x = kids[j];
      tree[x] = (ref2 = tree[x]) != null ? ref2 : {};
    }
    return tree;
  },
  getSnip: function() {
    return _snip;
  },
  gotSnip: function(path) {
    return !!_got_snip[path];
  },
  loadSnip: function(path, kids) {
    var i, len, v;
    this.mergePathToTree(path, _.pluck(kids, "name"));
    if ((kids != null ? kids.length : void 0) !== 0) {
      for (i = 0, len = kids.length; i < len; i++) {
        v = kids[i];
        _snip[path + "/" + v.name] = {
          head: {
            gn: 'h1',
            c: v.head
          },
          body: {
            gn: 'div',
            c: v.snip
          },
          meta: v.meta
        };
      }
    } else {
      _cont[path] = {
        gn: 'div',
        c: [
          {
            gn: 'h1',
            ga: {
              className: 'error'
            },
            c: ['Error: Empty path']
          }, {
            gn: 'div',
            c: [
              {
                gn: 'pre',
                c: [this.getCurr()]
              }, {
                gn: 'span',
                c: ['is either empty or does not exist.']
              }
            ]
          }
        ]
      };
    }
    return _got_snip[path] = true;
  },
  loadKids: function(path, kids) {
    var k, results, v;
    this.mergePathToTree(path, _.pluck(kids, "name"));
    results = [];
    for (k in kids) {
      v = kids[k];
      results.push(_cont[path + "/" + v.name] = v.body);
    }
    return results;
  },
  loadPath: function(path, body, kids) {
    this.mergePathToTree(path, _.pluck(kids, "name"));
    return _cont[path] = body;
  },
  getKids: function(path) {
    if (path == null) {
      path = _curr;
    }
    return _.keys(this.getTree(path.split("/")));
  },
  getSiblings: function(path) {
    var curr;
    if (path == null) {
      path = _curr;
    }
    curr = path.split("/");
    curr.pop();
    if (curr.length !== 0) {
      return this.getTree(curr);
    } else {
      return {};
    }
  },
  getPrev: function(path) {
    var ind, key, par, sibs, win;
    if (path == null) {
      path = _curr;
    }
    sibs = _.keys(this.getSiblings(path)).sort();
    if (sibs.length < 2) {
      return null;
    } else {
      par = _curr.split("/");
      key = par.pop();
      ind = sibs.indexOf(key);
      win = ind - 1 >= 0 ? sibs[ind - 1] : sibs[sibs.length - 1];
      par.push(win);
      return par.join("/");
    }
  },
  getNext: function(path) {
    var ind, key, par, sibs, win;
    if (path == null) {
      path = _curr;
    }
    sibs = _.keys(this.getSiblings(path)).sort();
    if (sibs.length < 2) {
      return null;
    } else {
      par = _curr.split("/");
      key = par.pop();
      ind = sibs.indexOf(key);
      win = ind + 1 < sibs.length ? sibs[ind + 1] : sibs[0];
      par.push(win);
      return par.join("/");
    }
  },
  getPare: function(path) {
    var _path;
    if (path == null) {
      path = _curr;
    }
    _path = this.pathToArr(path);
    if (_path.length > 1) {
      _path.pop();
      _path = _path.join("/");
      if (_path === "") {
        _path = "/";
      }
      return _path;
    } else {
      return null;
    }
  },
  getCrumbs: function(path) {
    var _path, crum, crums, k, v;
    if (path == null) {
      path = _curr;
    }
    _path = this.pathToArr(path);
    crum = "";
    crums = [];
    for (k in _path) {
      v = _path[k];
      crum += "/" + v;
      crums.push({
        name: v,
        path: crum
      });
    }
    return crums;
  },
  getBody: function() {
    if (_cont[_curr]) {
      return _cont[_curr];
    } else {
      return null;
    }
  }
});

TreeStore.dispatchToken = MessageDispatcher.register(function(payload) {
  var action;
  action = payload.action;
  switch (action.type) {
    case 'path-load':
      TreeStore.loadPath(action.path, action.body, action.kids, action.snip);
      return TreeStore.emitChange();
    case 'snip-load':
      TreeStore.loadSnip(action.path, action.kids);
      return TreeStore.emitChange();
    case 'kids-load':
      TreeStore.loadKids(action.path, action.kids);
      return TreeStore.emitChange();
    case 'set-curr':
      TreeStore.setCurr(action.path);
      return TreeStore.emitChange();
  }
});

module.exports = TreeStore;


},{"../dispatcher/Dispatcher.coffee":11,"events":19}],19:[function(require,module,exports){
// Copyright Joyent, Inc. and other Node contributors.
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to permit
// persons to whom the Software is furnished to do so, subject to the
// following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
// NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
// USE OR OTHER DEALINGS IN THE SOFTWARE.

function EventEmitter() {
  this._events = this._events || {};
  this._maxListeners = this._maxListeners || undefined;
}
module.exports = EventEmitter;

// Backwards-compat with node 0.10.x
EventEmitter.EventEmitter = EventEmitter;

EventEmitter.prototype._events = undefined;
EventEmitter.prototype._maxListeners = undefined;

// By default EventEmitters will print a warning if more than 10 listeners are
// added to it. This is a useful default which helps finding memory leaks.
EventEmitter.defaultMaxListeners = 10;

// Obviously not all Emitters should be limited to 10. This function allows
// that to be increased. Set to zero for unlimited.
EventEmitter.prototype.setMaxListeners = function(n) {
  if (!isNumber(n) || n < 0 || isNaN(n))
    throw TypeError('n must be a positive number');
  this._maxListeners = n;
  return this;
};

EventEmitter.prototype.emit = function(type) {
  var er, handler, len, args, i, listeners;

  if (!this._events)
    this._events = {};

  // If there is no 'error' event listener then throw.
  if (type === 'error') {
    if (!this._events.error ||
        (isObject(this._events.error) && !this._events.error.length)) {
      er = arguments[1];
      if (er instanceof Error) {
        throw er; // Unhandled 'error' event
      }
      throw TypeError('Uncaught, unspecified "error" event.');
    }
  }

  handler = this._events[type];

  if (isUndefined(handler))
    return false;

  if (isFunction(handler)) {
    switch (arguments.length) {
      // fast cases
      case 1:
        handler.call(this);
        break;
      case 2:
        handler.call(this, arguments[1]);
        break;
      case 3:
        handler.call(this, arguments[1], arguments[2]);
        break;
      // slower
      default:
        len = arguments.length;
        args = new Array(len - 1);
        for (i = 1; i < len; i++)
          args[i - 1] = arguments[i];
        handler.apply(this, args);
    }
  } else if (isObject(handler)) {
    len = arguments.length;
    args = new Array(len - 1);
    for (i = 1; i < len; i++)
      args[i - 1] = arguments[i];

    listeners = handler.slice();
    len = listeners.length;
    for (i = 0; i < len; i++)
      listeners[i].apply(this, args);
  }

  return true;
};

EventEmitter.prototype.addListener = function(type, listener) {
  var m;

  if (!isFunction(listener))
    throw TypeError('listener must be a function');

  if (!this._events)
    this._events = {};

  // To avoid recursion in the case that type === "newListener"! Before
  // adding it to the listeners, first emit "newListener".
  if (this._events.newListener)
    this.emit('newListener', type,
              isFunction(listener.listener) ?
              listener.listener : listener);

  if (!this._events[type])
    // Optimize the case of one listener. Don't need the extra array object.
    this._events[type] = listener;
  else if (isObject(this._events[type]))
    // If we've already got an array, just append.
    this._events[type].push(listener);
  else
    // Adding the second element, need to change to array.
    this._events[type] = [this._events[type], listener];

  // Check for listener leak
  if (isObject(this._events[type]) && !this._events[type].warned) {
    var m;
    if (!isUndefined(this._maxListeners)) {
      m = this._maxListeners;
    } else {
      m = EventEmitter.defaultMaxListeners;
    }

    if (m && m > 0 && this._events[type].length > m) {
      this._events[type].warned = true;
      console.error('(node) warning: possible EventEmitter memory ' +
                    'leak detected. %d listeners added. ' +
                    'Use emitter.setMaxListeners() to increase limit.',
                    this._events[type].length);
      if (typeof console.trace === 'function') {
        // not supported in IE 10
        console.trace();
      }
    }
  }

  return this;
};

EventEmitter.prototype.on = EventEmitter.prototype.addListener;

EventEmitter.prototype.once = function(type, listener) {
  if (!isFunction(listener))
    throw TypeError('listener must be a function');

  var fired = false;

  function g() {
    this.removeListener(type, g);

    if (!fired) {
      fired = true;
      listener.apply(this, arguments);
    }
  }

  g.listener = listener;
  this.on(type, g);

  return this;
};

// emits a 'removeListener' event iff the listener was removed
EventEmitter.prototype.removeListener = function(type, listener) {
  var list, position, length, i;

  if (!isFunction(listener))
    throw TypeError('listener must be a function');

  if (!this._events || !this._events[type])
    return this;

  list = this._events[type];
  length = list.length;
  position = -1;

  if (list === listener ||
      (isFunction(list.listener) && list.listener === listener)) {
    delete this._events[type];
    if (this._events.removeListener)
      this.emit('removeListener', type, listener);

  } else if (isObject(list)) {
    for (i = length; i-- > 0;) {
      if (list[i] === listener ||
          (list[i].listener && list[i].listener === listener)) {
        position = i;
        break;
      }
    }

    if (position < 0)
      return this;

    if (list.length === 1) {
      list.length = 0;
      delete this._events[type];
    } else {
      list.splice(position, 1);
    }

    if (this._events.removeListener)
      this.emit('removeListener', type, listener);
  }

  return this;
};

EventEmitter.prototype.removeAllListeners = function(type) {
  var key, listeners;

  if (!this._events)
    return this;

  // not listening for removeListener, no need to emit
  if (!this._events.removeListener) {
    if (arguments.length === 0)
      this._events = {};
    else if (this._events[type])
      delete this._events[type];
    return this;
  }

  // emit removeListener for all listeners on all events
  if (arguments.length === 0) {
    for (key in this._events) {
      if (key === 'removeListener') continue;
      this.removeAllListeners(key);
    }
    this.removeAllListeners('removeListener');
    this._events = {};
    return this;
  }

  listeners = this._events[type];

  if (isFunction(listeners)) {
    this.removeListener(type, listeners);
  } else {
    // LIFO order
    while (listeners.length)
      this.removeListener(type, listeners[listeners.length - 1]);
  }
  delete this._events[type];

  return this;
};

EventEmitter.prototype.listeners = function(type) {
  var ret;
  if (!this._events || !this._events[type])
    ret = [];
  else if (isFunction(this._events[type]))
    ret = [this._events[type]];
  else
    ret = this._events[type].slice();
  return ret;
};

EventEmitter.listenerCount = function(emitter, type) {
  var ret;
  if (!emitter._events || !emitter._events[type])
    ret = 0;
  else if (isFunction(emitter._events[type]))
    ret = 1;
  else
    ret = emitter._events[type].length;
  return ret;
};

function isFunction(arg) {
  return typeof arg === 'function';
}

function isNumber(arg) {
  return typeof arg === 'number';
}

function isObject(arg) {
  return typeof arg === 'object' && arg !== null;
}

function isUndefined(arg) {
  return arg === void 0;
}

},{}]},{},[12]);
