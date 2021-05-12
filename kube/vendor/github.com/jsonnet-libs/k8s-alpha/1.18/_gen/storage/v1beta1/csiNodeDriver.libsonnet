{
  local d = (import 'doc-util/main.libsonnet'),
  '#':: d.pkg(name='csiNodeDriver', url='', help='CSINodeDriver holds information about the specification of one CSI driver installed on a node'),
  '#allocatable':: d.obj(help='VolumeNodeResources is a set of resource limits for scheduling of volumes.'),
  allocatable: {
    '#withCount':: d.fn(help='Maximum number of unique volumes managed by the CSI driver that can be used on a node. A volume that is both attached and mounted on a node is considered to be used once, not twice. The same rule applies for a unique volume that is shared among multiple pods on the same node. If this field is nil, then the supported number of volumes on this node is unbounded.', args=[d.arg(name='count', type=d.T.integer)]),
    withCount(count): { allocatable+: { count: count } },
  },
  '#withName':: d.fn(help='This is the name of the CSI driver that this object refers to. This MUST be the same name returned by the CSI GetPluginName() call for that driver.', args=[d.arg(name='name', type=d.T.string)]),
  withName(name): { name: name },
  '#withNodeID':: d.fn(help='nodeID of the node from the driver point of view. This field enables Kubernetes to communicate with storage systems that do not share the same nomenclature for nodes. For example, Kubernetes may refer to a given node as "node1", but the storage system may refer to the same node as "nodeA". When Kubernetes issues a command to the storage system to attach a volume to a specific node, it can use this field to refer to the node name using the ID that the storage system will understand, e.g. "nodeA" instead of "node1". This field is required.', args=[d.arg(name='nodeID', type=d.T.string)]),
  withNodeID(nodeID): { nodeID: nodeID },
  '#withTopologyKeys':: d.fn(help='topologyKeys is the list of keys supported by the driver. When a driver is initialized on a cluster, it provides a set of topology keys that it understands (e.g. "company.com/zone", "company.com/region"). When a driver is initialized on a node, it provides the same topology keys along with values. Kubelet will expose these topology keys as labels on its own node object. When Kubernetes does topology aware provisioning, it can use this list to determine which labels it should retrieve from the node object and pass back to the driver. It is possible for different nodes to use different topology keys. This can be empty if driver does not support topology.', args=[d.arg(name='topologyKeys', type=d.T.array)]),
  withTopologyKeys(topologyKeys): { topologyKeys: if std.isArray(v=topologyKeys) then topologyKeys else [topologyKeys] },
  '#withTopologyKeysMixin':: d.fn(help='topologyKeys is the list of keys supported by the driver. When a driver is initialized on a cluster, it provides a set of topology keys that it understands (e.g. "company.com/zone", "company.com/region"). When a driver is initialized on a node, it provides the same topology keys along with values. Kubelet will expose these topology keys as labels on its own node object. When Kubernetes does topology aware provisioning, it can use this list to determine which labels it should retrieve from the node object and pass back to the driver. It is possible for different nodes to use different topology keys. This can be empty if driver does not support topology.\n\n**Note:** This function appends passed data to existing values', args=[d.arg(name='topologyKeys', type=d.T.array)]),
  withTopologyKeysMixin(topologyKeys): { topologyKeys+: if std.isArray(v=topologyKeys) then topologyKeys else [topologyKeys] },
  '#mixin': 'ignore',
  mixin: self,
}
