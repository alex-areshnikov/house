export default [
  { name: "name", selector: ".lot-details-heading .title" },
  { name: "vin", selector: "#vinDiv" },
  { name: "primary_damage", selector: "span[data-uname='lotdetailPrimarydamagevalue']" },
  { name: "secondary_damage", selector: "span[data-uname='lotdetailSecondarydamagevalue']" },
  // { name: "estimated_retail_value", selector: "span[data-uname='lotdetailEstimatedretailvalue']" },
  { name: "sale_date", selector: "[data-uname='lotdetailSaleinformationsaledatevalue']" },
  // { name: "last_updated", selector: "span[data-uname='lotdetailSaleinformationlastupdatedvalue']" }
  { name: "doc_type", selector: "[data-uname='lotdetailTitledescriptionvalue']" },
  { name: "odometer", selector: "[data-uname='lotdetailOdometervalue']" },
  { name: "engine_type", selector: "[data-uname='lotdetailEnginetype']" },
  { name: "location", selector: "[data-uname='lotdetailSaleinformationlocationvalue']" },
]
