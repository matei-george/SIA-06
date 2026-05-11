package org.datasource;

import org.datasource.jpa.JPADataSourceConnector;
import org.datasource.jpa.views.product.ProductView;
import org.datasource.jpa.views.product.ProductViewBuilder;
import org.datasource.jpa.views.sales.SalesView;
import org.datasource.jpa.views.sales.SalesViewBuilderSQL;
import org.datasource.springdata.views.InvoiceView;
import org.datasource.springdata.views.InvoiceViewRepository;
import org.datasource.springdata.views.InvoicesSalesView;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.logging.Logger;

/*	REST Service URL
	http://localhost:8091/DSA_SQL_JPAService/rest/sales/SalesView
	http://localhost:8091/DSA_SQL_JPAService/rest/sales/ProductView

	http://localhost:8091/DSA_SQL_JPAService/rest/sales/InvoiceView
	http://localhost:8091/DSA_SQL_JPAService/rest/sales/InvoicesSalesView
*/
@RestController
@RequestMapping("/sales")
public class RESTViewServiceJPA {
	private static Logger logger = Logger.getLogger(RESTViewServiceJPA.class.getName());
	
	@RequestMapping(value = "/ping", method = RequestMethod.GET,
			produces = {MediaType.TEXT_PLAIN_VALUE})
	@ResponseBody
	public String pingDataSource() {
		logger.info(">>>> DSA-SQL-JPAService:: RESTViewService is Up!");
		return "Ping response from DSA-SQL-JPAService!";
	}
	
	@RequestMapping(value = "/SalesView", method = RequestMethod.GET,
			produces = {MediaType.APPLICATION_JSON_VALUE, MediaType.APPLICATION_XML_VALUE})
	@ResponseBody
	public List<SalesView> get_SalesView() {
		List<SalesView> viewList = this.salesViewBuilder.build().getSalesViewList();
		return viewList;
	}

	@RequestMapping(value = "/ProductView", method = RequestMethod.GET,
			produces = {MediaType.APPLICATION_JSON_VALUE, MediaType.APPLICATION_XML_VALUE})
	@ResponseBody
	public List<ProductView> get_ProductView() {
		List<ProductView> viewList = this.productViewBuilder.build().getProductViewList();
		return viewList;
	}
	
	// Set-up
	@Autowired private JPADataSourceConnector dataSourceConnector;
	@Autowired private SalesViewBuilderSQL salesViewBuilder;
	@Autowired private ProductViewBuilder productViewBuilder;
	@Autowired private InvoiceViewRepository invoiceViewRepository;
	//

	@RequestMapping(value = "/InvoiceView", method = RequestMethod.GET,
			produces = {MediaType.APPLICATION_JSON_VALUE, MediaType.APPLICATION_XML_VALUE})
	@ResponseBody
	public List<InvoiceView> get_InvoiceView() {
		List<InvoiceView> viewList = this.invoiceViewRepository.findAll();
		return viewList;
	}

	@RequestMapping(value = "/InvoicesSalesView", method = RequestMethod.GET,
			produces = {MediaType.APPLICATION_JSON_VALUE, MediaType.APPLICATION_XML_VALUE})
	@ResponseBody
	public List<InvoicesSalesView> get_InvoicesSalesView() {
		List<InvoicesSalesView> viewList = this.invoiceViewRepository.getInvoicesSalesViewList();
		return viewList;
	}
}