Principles
  * everything has a canonical text-only representation
  * any node can be put into this mode

Templating
  * manipulation control
  * complex data types
  * structured data types that include arbitrary permissions
  * switch between "object view" and "pretty view" ?

== How is a complex type represented as a HumonNode structure?
e.g., what is inside the nodeVal? does it contain additional child nodes?


If complex types are essentially just big blobs, how does j2hn know to parse it as a complex type?

class HumonNode
  nodeType
  nodeVal


Approaches
  Assume we already have a complex-type, templated, in the page. How do we interact with it?

Examples of complex objects
  * tag list
  * time-stamped-object
