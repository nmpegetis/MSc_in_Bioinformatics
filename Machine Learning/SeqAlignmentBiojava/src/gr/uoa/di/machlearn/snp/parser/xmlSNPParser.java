package gr.uoa.di.machlearn.snp.parser;

import java.io.BufferedWriter;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.charset.Charset;
import java.util.HashMap;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.biojava.bio.BioException;
import org.biojava.bio.seq.DNATools;
import org.biojava.bio.symbol.SimpleSymbolList;
import org.biojava.bio.symbol.Symbol;
import org.biojava.bio.symbol.SymbolList;
//import org.biojava.bio.program.sax.SequenceAlignmentSAXParser;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;


public class xmlSNPParser {

	Document dom;

//	private ExchangeSet es = null;
	static PrintWriter writer = null;

	public xmlSNPParser() {
		super();
		try {
			writer = new PrintWriter(new BufferedWriter(new FileWriter("/RVMdata/vulvovaginal_output.txt",true)));	//every time we have to delete the previous file and re-create a new one, so that it has the new data
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
	}

	public void parseXML(String xml) throws IOException, BioException {
		System.out.println("Parsing XML.");
		System.out.println("Parsing branching points. Xml: "+xml);
		// parse the xml string and get the dom object
		parseXmlString(xml);

		// get each branching point element and create a map of branching points
		// object
		parseBPDocument();
	}

	
	private void parseXmlString(String xml) {
		// get the factory
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();

		try {

			// Using factory get an instance of document builder
			DocumentBuilder db = dbf.newDocumentBuilder();

			// parse using builder to get DOM representation of the XML string
			dom = db.parse(new InputSource(new ByteArrayInputStream(xml.getBytes("utf-8"))));

		} catch (ParserConfigurationException pce) {
			pce.printStackTrace();
		} catch (SAXException se) {
			se.printStackTrace();
		} catch (IOException ioe) {
			ioe.printStackTrace();
		}
	}

	private void parseBPDocument() throws IOException, BioException {
		// get the root elememt

		int maxSs = 0;
		int maxSequence = 0;
		int maxAssembly = 0;
		int maxComponent = 0;
		int maxMapLoc = 0;
		int maxFxnSet = 0;
		int maxSnpStat = 0;
		int maxPrimarySequence = 0;
		int maxMapLoc2 = 0;
		int maxRsStruct = 0;
		int maxhgvs = 0;
		int maxAlleleOrigin = 0;
		
		StringBuffer buffer = new StringBuffer();

		Element docEle = dom.getDocumentElement();

		System.out.println("\nXML RS: ");

		HashMap<String,Integer> bfmap = new HashMap<String,Integer>();
		HashMap<String,Integer> seq5map = new HashMap<String,Integer>();
		HashMap<String,Integer> seq3map = new HashMap<String,Integer>();
		HashMap<Integer,String> seq3map_rev = new HashMap<Integer,String>();
		HashMap<Integer,String> seq5map_rev = new HashMap<Integer,String>();
		HashMap<String,Integer> glmap = new HashMap<String,Integer>();
		HashMap<String,Integer> asmap = new HashMap<String,Integer>();
		HashMap<String,Integer> chrommap = new HashMap<String,Integer>();
		HashMap<String,Integer> gimap = new HashMap<String,Integer>();
		HashMap<String,Integer> grtmap = new HashMap<String,Integer>();
		HashMap<String,Integer> clmap = new HashMap<String,Integer>();
		HashMap<String,Integer> genemap = new HashMap<String,Integer>();
		HashMap<String,Integer> symmap = new HashMap<String,Integer>();
		HashMap<String,Integer> pgimap = new HashMap<String,Integer>();
		HashMap<String,Integer> accmap = new HashMap<String,Integer>();
		HashMap<String,Integer> pamap = new HashMap<String,Integer>();
		HashMap<String,Integer> sgimap = new HashMap<String,Integer>();
		HashMap<String,Integer> hgvsmap = new HashMap<String,Integer>();
		
		// get a nodelist of <branching_point> elements
//<RS>
		NodeList nl = docEle.getElementsByTagName("Rs");
		if (nl != null && nl.getLength() > 0) {
			for (int i = 0; i < nl.getLength(); i++) {

				// get the "Rs" element
				Element el = (Element) nl.item(i);

				// WRITE ITEMS
				buffer.append(el.getAttribute("rsId"));
				buffer.append('\t');
				if (el.getAttribute("snpClass").equals("snp")){
					buffer.append("1");
					buffer.append('\t');
				}
				else if (el.getAttribute("snpClass").equals("in-del")){
					buffer.append("2");
					buffer.append('\t');
				}
				else if (el.getAttribute("snpClass").equals("multinucleotide-polymorphism")){
					buffer.append("3");
					buffer.append('\t');
				}
				else {
					buffer.append("4");
					buffer.append('\t');
				}
				if (el.getAttribute("snpType").equals("notwithdrawn")){
					buffer.append("1");					
					buffer.append('\t');
				}
				else {
					buffer.append("2");
					buffer.append('\t');
				}
				if (el.getAttribute("molType").equals("genomic")){
					buffer.append("1");
					buffer.append('\t');
				}
				else if (el.getAttribute("molType").equals("cDNA")){
					buffer.append("2");
					buffer.append('\t');
				}
				else {
					buffer.append("3");
					buffer.append('\t');					
				}
				
				Integer identifier = 1;
				if (bfmap.containsKey(el.getAttribute("bitField"))){
					buffer.append(bfmap.get(el.getAttribute("bitField")).toString());
					buffer.append('\t');							
				}
				else {
					bfmap.put(el.getAttribute("bitField"), identifier);
					buffer.append(bfmap.get(el.getAttribute("bitField")).toString());
					buffer.append('\t');							
					identifier++;
				}
				buffer.append(el.getAttribute("taxId"));
				buffer.append('\t');
//<Rs>
//<Het>															<Het> tag does not exist in every <Rs> tag so we omit it
/*				NodeList nl1_1 = el.getElementsByTagName("Het");
				if (nl1_1 != null && nl1_1.getLength() > 0) {
					for (int j = 0; j < nl1_1.getLength(); j++) {
						// get the "Het" element
						Element el1 = (Element) nl1_1.item(j);
						// WRITE ITEMS
						if (el1.getAttribute("type").equals("est")){
							buffer.append("1");
							buffer.append('\t');							
						}
						else {
							buffer.append("2");
							buffer.append('\t');							
						}
						buffer.append(el1.getAttribute("value"));
						buffer.append('\t');
						buffer.append(el1.getAttribute("stdError"));
						buffer.append('\t');
					}
				}
				else {	
					buffer.append("0");
					buffer.append('\t');
					buffer.append("0");
					buffer.append('\t');
					buffer.append("0");
					buffer.append('\t');
				}
*/
//<Het>
//<Ss>
				NodeList nl1_3 = el.getElementsByTagName("Ss");
				if (nl1_3 != null && nl1_3.getLength() > 0) {
					Double mean_subSnpClass = 0.0;
					Integer subSnpClass = 0;
					Double mean_orient = 0.0;
					Integer orient = 0;
					Double mean_strand = 0.0;
					Integer strand = 0;
					Double mean_molType = 0.0;
					Integer molType = 0;
					Double mean_methodClass = 0.0;
					Integer methodClass = 0;
					Double mean_validated = 0.0;
					Integer validated = 0;
					String seq5String = null;
					Double mean_seq5a = 0.0;
					Double mean_seq5t = 0.0;
					Double mean_seq5g = 0.0;
					Double mean_seq5c = 0.0;
					Double mean_seq5gc = 0.0;
					Double mean_seq5ac = 0.0;
					Double mean_seq5ag = 0.0;
					Double mean_seq5at = 0.0;
					Double mean_seq5gt = 0.0;
					Double mean_seq5ct = 0.0;
					Double mean_seq5ratio_at = 0.0;
					Double mean_seq5ratio_ag = 0.0;
					Double mean_seq5ratio_ac = 0.0;
					Double mean_seq5ratio_tg = 0.0;
					Double mean_seq5ratio_tc = 0.0;
					Double mean_seq5ratio_gc = 0.0;
					Double mean_seq5ratio_at_gc = 0.0;
					Double mean_seq5ratio_ac_gt = 0.0;
					Double mean_seq5ratio_ag_ct = 0.0;
					Double mean_seq5ratio_a_gt = 0.0;
					Double mean_seq5ratio_a_gc = 0.0;
					Double mean_seq5ratio_a_ct = 0.0;
					Double mean_seq5ratio_t_ag = 0.0;
					Double mean_seq5ratio_t_gc = 0.0;
					Double mean_seq5ratio_t_ac = 0.0;
					Double mean_seq5ratio_g_at = 0.0;
					Double mean_seq5ratio_g_ac = 0.0;
					Double mean_seq5ratio_g_ct = 0.0;
					Double mean_seq5ratio_c_at = 0.0;
					Double mean_seq5ratio_c_ag = 0.0;
					Double mean_seq5ratio_c_gt = 0.0;
					Double mean_seq5a_a = 0.0;
					Double mean_seq5a_t = 0.0;
					Double mean_seq5a_g = 0.0;
					Double mean_seq5a_c = 0.0;
					Double mean_seq5t_t = 0.0;
					Double mean_seq5t_g = 0.0;
					Double mean_seq5t_c = 0.0;
					Double mean_seq5g_g = 0.0;
					Double mean_seq5g_c = 0.0;
					Double mean_seq5c_c = 0.0;
					Double mean_seq5aa_a = 0.0;
					Double mean_seq5aa_t = 0.0;
					Double mean_seq5aa_g = 0.0;
					Double mean_seq5aa_c = 0.0;
					Double mean_seq5tt_a = 0.0;
					Double mean_seq5tt_t = 0.0;
					Double mean_seq5tt_g = 0.0;
					Double mean_seq5tt_c = 0.0;
					Double mean_seq5gg_a = 0.0;
					Double mean_seq5gg_t = 0.0;
					Double mean_seq5gg_g = 0.0;
					Double mean_seq5gg_c = 0.0;
					Double mean_seq5cc_a = 0.0;
					Double mean_seq5cc_t = 0.0;
					Double mean_seq5cc_g = 0.0;
					Double mean_seq5cc_c = 0.0;
					int obs1=0;
					int obs2=0;
					int obs3=0;
					int obs4=0;
					int obs5=0;
					int obs6=0;
					int obs7=0;
					int obs8=0;
					int obs9=0;
					int obs10=0;
					int obs11=0;
					int obs12=0;
					int obs13=0;
					int obs14=0;
					int obs15=0;
					int obs16=0;
					int maxObs=0;
					Integer mostObs=0;
					String seq3String = null;
					Double mean_seq3a = 0.0;
					Double mean_seq3t = 0.0;
					Double mean_seq3g = 0.0;
					Double mean_seq3c = 0.0;
					Double mean_seq3gc = 0.0;
					Double mean_seq3ac = 0.0;
					Double mean_seq3ag = 0.0;
					Double mean_seq3at = 0.0;
					Double mean_seq3gt = 0.0;
					Double mean_seq3ct = 0.0;
					Double mean_seq3ratio_at = 0.0;
					Double mean_seq3ratio_ag = 0.0;
					Double mean_seq3ratio_ac = 0.0;
					Double mean_seq3ratio_tg = 0.0;
					Double mean_seq3ratio_tc = 0.0;
					Double mean_seq3ratio_gc = 0.0;
					Double mean_seq3ratio_at_gc = 0.0;
					Double mean_seq3ratio_ac_gt = 0.0;
					Double mean_seq3ratio_ag_ct = 0.0;
					Double mean_seq3ratio_a_gt = 0.0;
					Double mean_seq3ratio_a_gc = 0.0;
					Double mean_seq3ratio_a_ct = 0.0;
					Double mean_seq3ratio_t_ag = 0.0;
					Double mean_seq3ratio_t_gc = 0.0;
					Double mean_seq3ratio_t_ac = 0.0;
					Double mean_seq3ratio_g_at = 0.0;
					Double mean_seq3ratio_g_ac = 0.0;
					Double mean_seq3ratio_g_ct = 0.0;
					Double mean_seq3ratio_c_at = 0.0;
					Double mean_seq3ratio_c_ag = 0.0;
					Double mean_seq3ratio_c_gt = 0.0;
					Double mean_seq3a_a = 0.0;
					Double mean_seq3a_t = 0.0;
					Double mean_seq3a_g = 0.0;
					Double mean_seq3a_c = 0.0;
					Double mean_seq3t_t = 0.0;
					Double mean_seq3t_g = 0.0;
					Double mean_seq3t_c = 0.0;
					Double mean_seq3g_g = 0.0;
					Double mean_seq3g_c = 0.0;
					Double mean_seq3c_c = 0.0;
					Double mean_seq3aa_a = 0.0;
					Double mean_seq3aa_t = 0.0;
					Double mean_seq3aa_g = 0.0;
					Double mean_seq3aa_c = 0.0;
					Double mean_seq3tt_a = 0.0;
					Double mean_seq3tt_t = 0.0;
					Double mean_seq3tt_g = 0.0;
					Double mean_seq3tt_c = 0.0;
					Double mean_seq3gg_a = 0.0;
					Double mean_seq3gg_t = 0.0;
					Double mean_seq3gg_g = 0.0;
					Double mean_seq3gg_c = 0.0;
					Double mean_seq3cc_a = 0.0;
					Double mean_seq3cc_t = 0.0;
					Double mean_seq3cc_g = 0.0;
					Double mean_seq3cc_c = 0.0;
					Double mean_a_bonds = 0.0;
					Double mean_b_bonds = 0.0;
					Double mean_c_bonds = 0.0;
					Double mean_d_bonds = 0.0;
					Double mean_seq5pyrimidineSum = 0.0;
					Double mean_seq5purineSum = 0.0;
					Double mean_seq3pyrimidineSum = 0.0;
					Double mean_seq3purineSum = 0.0;
					for (int j = 0; j < nl1_3.getLength(); j++) {
						// get the "Ss" element
						if (j>maxSs)
							maxSs=j;
						Element el1 = (Element) nl1_3.item(j);
						// WRITE ITEMS
						if (el1.getAttribute("subSnpClass").equals("snp")){
							subSnpClass = 1;
//							buffer.append("1");
//							buffer.append('\t');
						}
						else {
							subSnpClass = 0;
//							buffer.append("0");
//							buffer.append('\t');		
						}
						mean_subSnpClass = (((j)*mean_subSnpClass)+subSnpClass)/(j+1);

						if (el1.getAttribute("orient").equals("forward")){
							orient = 1;
//							buffer.append("1");
//							buffer.append('\t');							
						}
						else {
							orient = 0;
//							buffer.append("0");
//							buffer.append('\t');										
						}
						mean_orient = (((j)*mean_orient)+orient)/(j+1);

						if (el1.getAttribute("strand").equals("top")){
							strand = 1;
//							buffer.append("1");
//							buffer.append('\t');							
						}
						else {
							strand = 0;
//							buffer.append("0");
//							buffer.append('\t');									
						}
						mean_strand = (((j)*mean_strand)+strand)/(j+1);

						if (el1.getAttribute("molType").equals("genomic")){
							molType = 1;
//							buffer.append("1");
//							buffer.append('\t');									
						}
						else{
							molType = 0;
//							buffer.append("0");
//							buffer.append('\t');									
						}
						mean_molType = (((j)*mean_molType)+molType)/(j+1);
						
						if (el1.getAttribute("methodClass").equals("sequence")){
							methodClass = 1;
//							buffer.append("1");
//							buffer.append('\t');							
						}
						else {
							methodClass = 0;
//							buffer.append("0");
//							buffer.append('\t');							
						}
						mean_methodClass = (((j)*mean_methodClass)+methodClass)/(j+1);
						
						if (el1.getAttribute("validated").equals("by-submitter")){
							validated = 1;
//							buffer.append("1");
//							buffer.append('\t');
						}
						else {
							validated = 0;
//							buffer.append("0");
//							buffer.append('\t');
						}
						mean_validated = (((j)*mean_validated)+validated)/(j+1);
						
//<Ss>
//<Sequence>						
//<Seq5>
						NodeList nl2_1 = el1.getElementsByTagName("Sequence");
						if (nl2_1 != null && nl2_1.getLength() > 0) {
							for (int k = 0; k < nl2_1.getLength(); k++) {
								// get the "Sequence" element
								if (k>maxSequence)
									maxSs=k;
								Element el2 = (Element) nl2_1.item(k);
								NodeList nl3_1 = el2.getElementsByTagName("Seq5");
								if (nl3_1 != null && nl3_1.getLength() > 0) {
									for (int l = 0; l < nl3_1.getLength(); l++) {
										// get the "Seq5" element
										//Element el3 = (Element) nl3_1.item(l);
										Integer seq5id4conserved = 1;			//we are going to check conserved areas

										// WRITE ITEMS
										seq5String = getTextValue(el2, "Seq5");
										if (seq5map.containsKey(seq5String)){
//											buffer.append(seq5map.get(seqString).toString());
//											buffer.append('\t');							
										}
										else {
											seq5map.put(seq5String, seq5id4conserved);
											seq5map_rev.put(seq5id4conserved, seq5String);
//											buffer.append(seq5map.get(seqString).toString());
//											buffer.append('\t');							
											seq5id4conserved++;
										}

										SymbolList forward = new SimpleSymbolList(DNATools.getDNA().getTokenization("token"), seq5String);

										int a = 0;
									    for (int pos = 1; pos <= forward.length(); ++pos) {
									    	Symbol sym = forward.symbolAt(pos);
											if (sym == DNATools.a())
											    ++a;
									    }
									    Double a_content = ((a * 100.0) / forward.length());
//										buffer.append(a_content.toString());
//										buffer.append('\t');
										mean_seq5a = (((j)*mean_seq5a)+a_content)/(j+1);

										int t = 0;
									    for (int pos = 1; pos <= forward.length(); ++pos) {
									    	Symbol sym = forward.symbolAt(pos);
											if (sym == DNATools.t())
											    ++t;
									    }
									    Double t_content = ((t * 100.0) / forward.length());
//										buffer.append(t_content.toString());
//										buffer.append('\t');
										mean_seq5t = (((j)*mean_seq5t)+t_content)/(j+1);

										int g = 0;
									    for (int pos = 1; pos <= forward.length(); ++pos) {
									    	Symbol sym = forward.symbolAt(pos);
											if (sym == DNATools.g())
											    ++g;
									    }
									    Double g_content = ((g * 100.0) / forward.length());
//										buffer.append(g_content.toString());
//										buffer.append('\t');
										mean_seq5g = (((j)*mean_seq5g)+g_content)/(j+1);

										int c = 0;
									    for (int pos = 1; pos <= forward.length(); ++pos) {
									    	Symbol sym = forward.symbolAt(pos);
											if (sym == DNATools.c())
											    ++c;
									    }
									    Double c_content = ((c * 100.0) / forward.length());
//										buffer.append(c_content.toString());
//										buffer.append('\t');
										mean_seq5c = (((j)*mean_seq5c)+c_content)/(j+1);

										int gc = 0;
									    for (int pos = 1; pos <= forward.length(); ++pos) {
									    	Symbol sym = forward.symbolAt(pos);
											if (sym == DNATools.g() || sym == DNATools.c())
											    ++gc;
									    }
									    Double gc_content = ((gc * 100.0) / forward.length());
										//buffer.append(seqString);
										//buffer.append('\t');
//										buffer.append(gc_content.toString());
//										buffer.append('\t');
										mean_seq5gc = (((j)*mean_seq5gc)+gc_content)/(j+1);
										
										int ac = 0;
									    for (int pos = 1; pos <= forward.length(); ++pos) {
									    	Symbol sym = forward.symbolAt(pos);
											if (sym == DNATools.a() || sym == DNATools.c())
											    ++ac;
									    }
									    Double ac_content = ((ac * 100.0) / forward.length());
//										buffer.append(ac_content.toString());
//										buffer.append('\t');
										mean_seq5ac = (((j)*mean_seq5ac)+ac_content)/(j+1);

										int ag = 0;
									    for (int pos = 1; pos <= forward.length(); ++pos) {
									    	Symbol sym = forward.symbolAt(pos);
											if (sym == DNATools.a() || sym == DNATools.g())
											    ++ag;
									    }
									    Double ag_content = ((ag * 100.0) / forward.length());
//										buffer.append(ag_content.toString());
//										buffer.append('\t');
										mean_seq5ag = (((j)*mean_seq5ag)+ag_content)/(j+1);

										int at = 0;
									    for (int pos = 1; pos <= forward.length(); ++pos) {
									    	Symbol sym = forward.symbolAt(pos);
											if (sym == DNATools.a() || sym == DNATools.t())
											    ++at;
									    }
									    Double at_content = ((at * 100.0) / forward.length());
//										buffer.append(at_content.toString());
//										buffer.append('\t');
										mean_seq5at = (((j)*mean_seq5at)+at_content)/(j+1);

										int gt = 0;
									    for (int pos = 1; pos <= forward.length(); ++pos) {
									    	Symbol sym = forward.symbolAt(pos);
											if (sym == DNATools.g() || sym == DNATools.t())
											    ++gt;
									    }
									    Double gt_content = ((gt * 100.0) / forward.length());
//										buffer.append(gt_content.toString());
//										buffer.append('\t');
										mean_seq5gt = (((j)*mean_seq5gt)+gt_content)/(j+1);


										int ct = 0;
									    for (int pos = 1; pos <= forward.length(); ++pos) {
									    	Symbol sym = forward.symbolAt(pos);
											if (sym == DNATools.c() || sym == DNATools.t())
											    ++ct;
									    }
									    Double ct_content = ((ct * 100.0) / forward.length());
//										buffer.append(ct_content.toString());
//										buffer.append('\t');
										mean_seq5ct = (((j)*mean_seq5ct)+ct_content)/(j+1);
										
										Double ratio_a_t = a_content/t_content;
//										buffer.append(ratio_a_t.toString());
//										buffer.append('\t');
										mean_seq5ratio_at = (((j)*mean_seq5ratio_at)+ratio_a_t)/(j+1);
										Double ratio_a_g = a_content/g_content;
//										buffer.append(ratio_a_g.toString());
//										buffer.append('\t');
										mean_seq5ratio_ag = (((j)*mean_seq5ratio_ag)+ratio_a_g)/(j+1);

										Double ratio_a_c = a_content/c_content;
//										buffer.append(ratio_a_c.toString());
//										buffer.append('\t');
										mean_seq5ratio_ac = (((j)*mean_seq5ratio_ac)+ratio_a_c)/(j+1);

										Double ratio_t_g = t_content/g_content;
//										buffer.append(ratio_t_g.toString());
//										buffer.append('\t');
										mean_seq5ratio_tg = (((j)*mean_seq5ratio_tg)+ratio_t_g)/(j+1);

										Double ratio_t_c = t_content/c_content;
//										buffer.append(ratio_t_c.toString());
//										buffer.append('\t');
										mean_seq5ratio_tc = (((j)*mean_seq5ratio_tc)+ratio_t_c)/(j+1);

										Double ratio_g_c = g_content/c_content;
//										buffer.append(ratio_g_c.toString());
//										buffer.append('\t');
										mean_seq5ratio_gc = (((j)*mean_seq5ratio_gc)+ratio_g_c)/(j+1);

										Double ratio_at_gc = at_content/gc_content;
//										buffer.append(ratio_at_gc.toString());
//										buffer.append('\t');
										mean_seq5ratio_at_gc = (((j)*mean_seq5ratio_at_gc)+ratio_at_gc)/(j+1);

										Double ratio_ac_gt = ac_content/gt_content;
//										buffer.append(ratio_ac_gt.toString());
//										buffer.append('\t');
										mean_seq5ratio_ac_gt = (((j)*mean_seq5ratio_ac_gt)+ratio_ac_gt)/(j+1);

										Double ratio_ag_ct = ag_content/ct_content;
//										buffer.append(ratio_ag_ct.toString());
//										buffer.append('\t');
										mean_seq5ratio_ag_ct = (((j)*mean_seq5ratio_ag_ct)+ratio_ag_ct)/(j+1);

										Double ratio_a_gt = a_content/gt_content;
//										buffer.append(ratio_a_gt.toString());
//										buffer.append('\t');
										mean_seq5ratio_a_gt = (((j)*mean_seq5ratio_a_gt)+ratio_a_gt)/(j+1);

										Double ratio_a_gc = a_content/gc_content;
//										buffer.append(ratio_a_gc.toString());
//										buffer.append('\t');
										mean_seq5ratio_a_gc = (((j)*mean_seq5ratio_a_gc)+ratio_a_gc)/(j+1);

										Double ratio_a_ct = a_content/ct_content;
//										buffer.append(ratio_a_ct.toString());
//										buffer.append('\t');
										mean_seq5ratio_a_ct = (((j)*mean_seq5ratio_a_ct)+ratio_a_ct)/(j+1);

										Double ratio_t_ag = t_content/ag_content;
//										buffer.append(ratio_t_ag.toString());
//										buffer.append('\t');
										mean_seq5ratio_t_ag = (((j)*mean_seq5ratio_t_ag)+ratio_t_ag)/(j+1);										
										
										Double ratio_t_gc = t_content/gc_content;
//										buffer.append(ratio_t_gc.toString());
//										buffer.append('\t');
										mean_seq5ratio_t_gc = (((j)*mean_seq5ratio_t_gc)+ratio_t_gc)/(j+1);										

										Double ratio_t_ac = t_content/ac_content;
//										buffer.append(ratio_t_ac.toString());
//										buffer.append('\t');
										mean_seq5ratio_t_ac = (((j)*mean_seq5ratio_t_ac)+ratio_t_ac)/(j+1);										

										Double ratio_g_at = g_content/at_content;
//										buffer.append(ratio_g_at.toString());
//										buffer.append('\t');
										mean_seq5ratio_g_at = (((j)*mean_seq5ratio_g_at)+ratio_g_at)/(j+1);										

										Double ratio_g_ac = g_content/ac_content;
//										buffer.append(ratio_g_ac.toString());
//										buffer.append('\t');
										mean_seq5ratio_g_ac = (((j)*mean_seq5ratio_g_ac)+ratio_g_ac)/(j+1);										

										Double ratio_g_ct = g_content/ct_content;
//										buffer.append(ratio_g_ct.toString());
//										buffer.append('\t');
										mean_seq5ratio_g_ct = (((j)*mean_seq5ratio_g_ct)+ratio_g_ct)/(j+1);										

										Double ratio_c_at = c_content/at_content;
//										buffer.append(ratio_c_at.toString());
//										buffer.append('\t');
										mean_seq5ratio_c_at = (((j)*mean_seq5ratio_c_at)+ratio_c_at)/(j+1);										

										Double ratio_c_ag = c_content/ag_content;
//										buffer.append(ratio_c_ag.toString());
//										buffer.append('\t');
										mean_seq5ratio_c_ag = (((j)*mean_seq5ratio_c_ag)+ratio_c_ag)/(j+1);										

										Double ratio_c_gt = c_content/gt_content;
//										buffer.append(ratio_c_gt.toString());
//										buffer.append('\t');
										mean_seq5ratio_c_gt = (((j)*mean_seq5ratio_c_gt)+ratio_c_gt)/(j+1);										

										int aa = 0;
									    for (int pos = 1; pos <= forward.length()-1; ++pos) {
									    	String sym = forward.subStr(pos, pos+1);
											if (sym.equals("AA"))
											    ++aa;
									    }
									    
									    Double a_a_content = ((aa * 100.0) / forward.length());
//										buffer.append(a_a_content.toString());
//										buffer.append('\t');
										mean_seq5a_a = (((j)*mean_seq5a_a)+a_a_content)/(j+1);
										
										int a_t = 0;
									    for (int pos = 1; pos <= forward.length()-1; ++pos) {
									    	String sym = forward.subStr(pos, pos+1);
											if (sym.equals("AT"))
											    ++a_t;
									    }
									    
									    Double a_t_content = ((a_t * 100.0) / forward.length());
//										buffer.append(a_t_content.toString());
//										buffer.append('\t');
										mean_seq5a_t = (((j)*mean_seq5a_t)+a_t_content)/(j+1);
										
										int a_g = 0;
									    for (int pos = 1; pos <= forward.length()-1; ++pos) {
									    	String sym = forward.subStr(pos, pos+1);
											if (sym.equals("AG"))
											    ++a_g;
									    }
									    
									    Double a_g_content = ((a_g * 100.0) / forward.length());
//										buffer.append(a_g_content.toString());
//										buffer.append('\t');
										mean_seq5a_g = (((j)*mean_seq5a_g)+a_g_content)/(j+1);
										
										int a_c = 0;
									    for (int pos = 1; pos <= forward.length()-1; ++pos) {
									    	String sym = forward.subStr(pos, pos+1);
											if (sym.equals("AC"))
											    ++a_c;
									    }
									    
									    Double a_c_content = ((a_c * 100.0) / forward.length());
//										buffer.append(a_c_content.toString());
//										buffer.append('\t');
										mean_seq5a_c = (((j)*mean_seq5a_c)+a_c_content)/(j+1);
										
										int t_t = 0;
									    for (int pos = 1; pos <= forward.length()-1; ++pos) {
									    	String sym = forward.subStr(pos, pos+1);
											if (sym.equals("TT"))
											    ++t_t;
									    }
									    
									    Double t_t_content = ((t_t * 100.0) / forward.length());
//										buffer.append(t_t_content.toString());
//										buffer.append('\t');
										mean_seq5t_t = (((j)*mean_seq5t_t)+t_t_content)/(j+1);
										
										int t_g = 0;
									    for (int pos = 1; pos <= forward.length()-1; ++pos) {
									    	String sym = forward.subStr(pos, pos+1);
											if (sym.equals("TG"))
											    ++t_g;
									    }
									    
									    Double t_g_content = ((t_g * 100.0) / forward.length());
//										buffer.append(t_g_content.toString());
//										buffer.append('\t');
										mean_seq5t_g = (((j)*mean_seq5t_g)+t_g_content)/(j+1);
										
										int t_c = 0;
									    for (int pos = 1; pos <= forward.length()-1; ++pos) {
									    	String sym = forward.subStr(pos, pos+1);
											if (sym.equals("TC"))
											    ++t_c;
									    }
									    
									    Double t_c_content = ((t_c * 100.0) / forward.length());
//										buffer.append(t_c_content.toString());
//										buffer.append('\t');
										mean_seq5t_c = (((j)*mean_seq5t_c)+t_c_content)/(j+1);
										
										int g_g = 0;
									    for (int pos = 1; pos <= forward.length()-1; ++pos) {
									    	String sym = forward.subStr(pos, pos+1);
											if (sym.equals("GG"))
											    ++g_g;
									    }
									    
									    Double g_g_content = ((g_g * 100.0) / forward.length());
//										buffer.append(g_g_content.toString());
//										buffer.append('\t');
										mean_seq5g_g = (((j)*mean_seq5g_g)+g_g_content)/(j+1);
										
										int g_c = 0;
									    for (int pos = 1; pos <= forward.length()-1; ++pos) {
									    	String sym = forward.subStr(pos, pos+1);
											if (sym.equals("GC"))
											    ++g_c;
									    }
									    
									    Double g_c_content = ((g_c * 100.0) / forward.length());
//										buffer.append(g_c_content.toString());
//										buffer.append('\t');
										mean_seq5g_c = (((j)*mean_seq5g_c)+g_c_content)/(j+1);
										
										int c_c = 0;
									    for (int pos = 1; pos <= forward.length()-1; ++pos) {
									    	String sym = forward.subStr(pos, pos+1);
											if (sym.equals("CC"))
											    ++c_c;
									    }
									    
									    Double c_c_content = ((c_c * 100.0) / forward.length());
//										buffer.append(c_c_content.toString());
//										buffer.append('\t');
										mean_seq5c_c = (((j)*mean_seq5c_c)+c_c_content)/(j+1);
									
										int aa_a = 0;
									    for (int pos = 1; pos <= forward.length()-2; ++pos) {
									    	String sym = forward.subStr(pos, pos+2);
											if (sym.equals("AAA"))
											    ++aa_a;
									    }
									    
									    Double aa_a_content = ((aa_a * 100.0) / forward.length());
//										buffer.append(aa_a_content.toString());
//										buffer.append('\t');
										mean_seq5aa_a = (((j)*mean_seq5aa_a)+aa_a_content)/(j+1);
										
										
										int aa_t = 0;
									    for (int pos = 1; pos <= forward.length()-2; ++pos) {
									    	String sym = forward.subStr(pos, pos+2);
											if (sym.equals("AAT"))
											    ++aa_t;
									    }
									    
									    Double aa_t_content = ((aa_t * 100.0) / forward.length());
//										buffer.append(aa_t_content.toString());
//										buffer.append('\t');
										mean_seq5aa_t = (((j)*mean_seq5aa_t)+aa_t_content)/(j+1);
										
										int aa_g = 0;
									    for (int pos = 1; pos <= forward.length()-2; ++pos) {
									    	String sym = forward.subStr(pos, pos+2);
											if (sym.equals("AAG"))
											    ++aa_g;
									    }
									    
									    Double aa_g_content = ((aa_g * 100.0) / forward.length());
//										buffer.append(aa_g_content.toString());
//										buffer.append('\t');
										mean_seq5aa_g = (((j)*mean_seq5aa_g)+aa_g_content)/(j+1);
										
										int aa_c = 0;
									    for (int pos = 1; pos <= forward.length()-2; ++pos) {
									    	String sym = forward.subStr(pos, pos+2);
											if (sym.equals("AAC"))
											    ++aa_c;
									    }
									    
									    Double aa_c_content = ((aa_c * 100.0) / forward.length());
//										buffer.append(aa_c_content.toString());
//										buffer.append('\t');
										mean_seq5aa_c = (((j)*mean_seq5aa_c)+aa_c_content)/(j+1);
										
										int tt_a = 0;
									    for (int pos = 1; pos <= forward.length()-2; ++pos) {
									    	String sym = forward.subStr(pos, pos+2);
											if (sym.equals("TTA"))
											    ++tt_a;
									    }
									    
									    Double tt_a_content = ((tt_a * 100.0) / forward.length());
//										buffer.append(tt_a_content.toString());
//										buffer.append('\t');
										mean_seq5tt_a = (((j)*mean_seq5tt_a)+tt_a_content)/(j+1);
										
										int tt_t = 0;
									    for (int pos = 1; pos <= forward.length()-2; ++pos) {
									    	String sym = forward.subStr(pos, pos+2);
											if (sym.equals("TTT"))
											    ++tt_t;
									    }
									    
									    Double tt_t_content = ((tt_t * 100.0) / forward.length());
//										buffer.append(tt_t_content.toString());
//										buffer.append('\t');
										mean_seq5tt_t = (((j)*mean_seq5tt_t)+tt_t_content)/(j+1);
										
										int tt_g = 0;
									    for (int pos = 1; pos <= forward.length()-2; ++pos) {
									    	String sym = forward.subStr(pos, pos+2);
											if (sym.equals("TTG"))
											    ++tt_g;
									    }
									    
									    Double tt_g_content = ((tt_g * 100.0) / forward.length());
//										buffer.append(tt_g_content.toString());
//										buffer.append('\t');
										mean_seq5tt_g = (((j)*mean_seq5tt_g)+tt_g_content)/(j+1);
										
										int tt_c = 0;
									    for (int pos = 1; pos <= forward.length()-2; ++pos) {
									    	String sym = forward.subStr(pos, pos+2);
											if (sym.equals("TTC"))
											    ++tt_c;
									    }
									    
									    Double tt_c_content = ((tt_c * 100.0) / forward.length());
//										buffer.append(tt_c_content.toString());
//										buffer.append('\t');
										mean_seq5tt_c = (((j)*mean_seq5tt_c)+tt_c_content)/(j+1);
										
										int gg_a = 0;
									    for (int pos = 1; pos <= forward.length()-2; ++pos) {
									    	String sym = forward.subStr(pos, pos+2);
											if (sym.equals("GGA"))
											    ++gg_a;
									    }
									    
									    Double gg_a_content = ((gg_a * 100.0) / forward.length());
//										buffer.append(gg_a_content.toString());
//										buffer.append('\t');
										mean_seq5gg_a = (((j)*mean_seq5gg_a)+gg_a_content)/(j+1);
										
										int gg_t = 0;
									    for (int pos = 1; pos <= forward.length()-2; ++pos) {
									    	String sym = forward.subStr(pos, pos+2);
											if (sym.equals("GGT"))
											    ++gg_t;
									    }
									    
									    Double gg_t_content = ((gg_t * 100.0) / forward.length());
//										buffer.append(gg_t_content.toString());
//										buffer.append('\t');
										mean_seq5gg_t = (((j)*mean_seq5gg_t)+gg_t_content)/(j+1);
										
										int gg_g = 0;
									    for (int pos = 1; pos <= forward.length()-2; ++pos) {
									    	String sym = forward.subStr(pos, pos+2);
											if (sym.equals("GGG"))
											    ++gg_g;
									    }
									    
									    Double gg_g_content = ((gg_g * 100.0) / forward.length());
//										buffer.append(gg_g_content.toString());
//										buffer.append('\t');
										mean_seq5gg_g = (((j)*mean_seq5gg_g)+gg_g_content)/(j+1);
										
										int gg_c = 0;
									    for (int pos = 1; pos <= forward.length()-2; ++pos) {
									    	String sym = forward.subStr(pos, pos+2);
											if (sym.equals("GGC"))
											    ++gg_c;
									    }
									    
									    Double gg_c_content = ((gg_c * 100.0) / forward.length());
//										buffer.append(gg_c_content.toString());
//										buffer.append('\t');
										mean_seq5gg_c = (((j)*mean_seq5gg_c)+gg_c_content)/(j+1);
										
										int cc_a = 0;
									    for (int pos = 1; pos <= forward.length()-2; ++pos) {
									    	String sym = forward.subStr(pos, pos+2);
											if (sym.equals("CCA"))
											    ++cc_a;
									    }
									    
									    Double cc_a_content = ((cc_a * 100.0) / forward.length());
//										buffer.append(cc_a_content.toString());
//										buffer.append('\t');
										mean_seq5cc_a = (((j)*mean_seq5cc_a)+cc_a_content)/(j+1);
										
										int cc_t = 0;
									    for (int pos = 1; pos <= forward.length()-2; ++pos) {
									    	String sym = forward.subStr(pos, pos+2);
											if (sym.equals("CCT"))
											    ++cc_t;
									    }
									    
									    Double cc_t_content = ((cc_t * 100.0) / forward.length());
//										buffer.append(cc_t_content.toString());
//										buffer.append('\t');
										mean_seq5cc_t = (((j)*mean_seq5cc_t)+cc_t_content)/(j+1);
										
										int cc_g = 0;
									    for (int pos = 1; pos <= forward.length()-2; ++pos) {
									    	String sym = forward.subStr(pos, pos+2);
											if (sym.equals("CCG"))
											    ++cc_g;
									    }
									    
									    Double cc_g_content = ((cc_g * 100.0) / forward.length());
//										buffer.append(cc_g_content.toString());
//										buffer.append('\t');
										mean_seq5cc_g = (((j)*mean_seq5cc_g)+cc_g_content)/(j+1);
										
										int cc_c = 0;
									    for (int pos = 1; pos <= forward.length()-2; ++pos) {
									    	String sym = forward.subStr(pos, pos+2);
											if (sym.equals("CCC"))
											    ++cc_c;
									    }
									    
									    Double cc_c_content = ((cc_c * 100.0) / forward.length());
//										buffer.append(cc_c_content.toString());
//										buffer.append('\t');
										mean_seq5cc_c = (((j)*mean_seq5cc_c)+cc_c_content)/(j+1);
									}
								}
								NodeList nl3_2 = el2.getElementsByTagName("Observed");
								if (nl3_2 != null && nl3_2.getLength() > 0) {
									for (int l = 0; l < nl3_2.getLength(); l++) {
										// get the "Observed" element
										//Element el3 = (Element) nl3_2.item(l);
										// WRITE ITEMS
										String str = getTextValue(el2, "Observed");
										if (str.equals("A")) {	//IUPAC codes
//										    System.out.println("Observed ="+str);	// A
											obs1++;
											if (maxObs<obs1){
												maxObs++;
												mostObs=1;
											}
//											buffer.append("1");
//											buffer.append('\t');											
										}
										else if (str.equals("C")) {	//IUPAC codes
//										    System.out.println("Observed ="+str);	// C
											obs2++;
											if (maxObs<obs2){
												maxObs++;
												mostObs=2;
											}
//											buffer.append("2");
//											buffer.append('\t');											
										}
										else if (str.equals("G")) {	//IUPAC codes
//										    System.out.println("Observed ="+str);	// G
											obs3++;
											if (maxObs<obs3){
												maxObs++;
												mostObs=3;
											}
//											buffer.append("3");
//											buffer.append('\t');											
										}
										else if (str.equals("T") || str.equals("U")) {	//IUPAC codes
//										    System.out.println("Observed ="+str);	// T/U
											obs4++;
											if (maxObs<obs4){
												maxObs++;
												mostObs=4;
											}
//											buffer.append("4");
//											buffer.append('\t');											
										}
										else if (str.equals("A/G")) {	//IUPAC codes
//										    System.out.println("Observed ="+str);	// R
											obs5++;
											if (maxObs<obs5){
												maxObs++;
												mostObs=5;
											}
//											buffer.append("5");
//											buffer.append('\t');											
										}
										else if (str.equals("C/T")) {	//IUPAC codes
//										    System.out.println("Observed ="+str);	// Y
											obs6++;
											if (maxObs<obs6){
												maxObs++;
												mostObs=6;
											}
//											buffer.append("6");
//											buffer.append('\t');											
										}
										else if (str.equals("G/C")) {	//IUPAC codes
//										    System.out.println("Observed ="+str);	// S
											obs7++;
											if (maxObs<obs7){
												maxObs++;
												mostObs=7;
											}
//											buffer.append("7");
//											buffer.append('\t');											
										}
										else if (str.equals("A/T")) {	//IUPAC codes
//										    System.out.println("Observed ="+str);	// W
											obs8++;
											if (maxObs<obs8){
												maxObs++;
												mostObs=8;
											}
//											buffer.append("8");
//											buffer.append('\t');											
										}
										else if (str.equals("G/T")) {	//IUPAC codes
//										    System.out.println("Observed ="+str);	// K
											obs9++;
											if (maxObs<obs9){
												maxObs++;
												mostObs=9;
											}
//											buffer.append("9");
//											buffer.append('\t');											
										}
										else if (str.equals("A/C")) {	//IUPAC codes
//										    System.out.println("Observed ="+str);	// M
											obs10++;
											if (maxObs<obs10){
												maxObs++;
												mostObs=10;
											}
//											buffer.append("10");
//											buffer.append('\t');											
										}
										else if (str.equals("C/G/T")) {	//IUPAC codes
//										    System.out.println("Observed ="+str);	// B
											obs11++;
											if (maxObs<obs11){
												maxObs++;
												mostObs=11;
											}
//											buffer.append("11");
//											buffer.append('\t');											
										}
										else if (str.equals("A/G/T")) {	//IUPAC codes
//										    System.out.println("Observed ="+str);	// D
											obs12++;
											if (maxObs<obs12){
												maxObs++;
												mostObs=12;
											}
//											buffer.append("12");
//											buffer.append('\t');											
										}
										else if (str.equals("A/C/T")) {	//IUPAC codes
//										    System.out.println("Observed ="+str);	// H
											obs13++;
											if (maxObs<obs13){
												maxObs++;
												mostObs=13;
											}
//											buffer.append("13");
//											buffer.append('\t');											
										}
										else if (str.equals("A/C/G")) {	//IUPAC codes
//										    System.out.println("Observed ="+str);	// V
											obs14++;
											if (maxObs<obs14){
												maxObs++;
												mostObs=14;
											}
//											buffer.append("14");
//											buffer.append('\t');											
										}
										else if (str.equals("N")) {	//IUPAC codes
//										    System.out.println("Observed ="+str);	// N (any base)
											obs15++;
											if (maxObs<obs15){
												maxObs++;
												mostObs=15;
											}
//											buffer.append("15");
//											buffer.append('\t');											
										}
										else {	//IUPAC codes
//										    System.out.println("Other");	// gap
											obs16++;
											if (maxObs<obs16){
												maxObs++;
												mostObs=16;
											}
//											buffer.append("16");
//											buffer.append('\t');											
										}
									}
								}
								NodeList nl3_3 = el2.getElementsByTagName("Seq3");
								if (nl3_3 != null && nl3_3.getLength() > 0) {
									for (int l = 0; l < nl3_3.getLength(); l++) {
										// get the "Seq3" element
										//Element el3 = (Element) nl3_3.item(l);
										// WRITE ITEMS
										Integer seq3id4conserved = 1;			//we are going to check conserved areas

										seq3String = getTextValue(el2, "Seq3");
										
										if (seq3map.containsKey(seq3String)){
//											buffer.append(seq3map.get(seqString).toString());
//											buffer.append('\t');							
										}
										else {
											seq3map.put(seq3String, seq3id4conserved);
											seq3map_rev.put(seq3id4conserved, seq3String);
//											buffer.append(seq3map.get(seqString).toString());
//											buffer.append('\t');							
											seq3id4conserved++;
										}

										SymbolList reverse = new SimpleSymbolList(DNATools.getDNA().getTokenization("token"), seq3String);

										int a = 0;
									    for (int pos = 1; pos <= reverse.length(); ++pos) {
									    	Symbol sym = reverse.symbolAt(pos);
											if (sym == DNATools.a())
											    ++a;
									    }
									    Double a_content = ((a * 100.0) / reverse.length());
//										buffer.append(a_content.toString());
//										buffer.append('\t');
										mean_seq3a = (((j)*mean_seq3a)+a_content)/(j+1);

										int t = 0;
									    for (int pos = 1; pos <= reverse.length(); ++pos) {
									    	Symbol sym = reverse.symbolAt(pos);
											if (sym == DNATools.t())
											    ++t;
									    }
									    Double t_content = ((t * 100.0) / reverse.length());
//										buffer.append(t_content.toString());
//										buffer.append('\t');
										mean_seq3t = (((j)*mean_seq3t)+t_content)/(j+1);

										int g = 0;
									    for (int pos = 1; pos <= reverse.length(); ++pos) {
									    	Symbol sym = reverse.symbolAt(pos);
											if (sym == DNATools.g())
											    ++g;
									    }
									    Double g_content = ((g * 100.0) / reverse.length());
//										buffer.append(g_content.toString());
//										buffer.append('\t');
										mean_seq3g = (((j)*mean_seq3g)+g_content)/(j+1);

										int c = 0;
									    for (int pos = 1; pos <= reverse.length(); ++pos) {
									    	Symbol sym = reverse.symbolAt(pos);
											if (sym == DNATools.c())
											    ++c;
									    }
									    Double c_content = ((c * 100.0) / reverse.length());
//										buffer.append(c_content.toString());
//										buffer.append('\t');
										mean_seq3c = (((j)*mean_seq3c)+c_content)/(j+1);

										int gc = 0;
									    for (int pos = 1; pos <= reverse.length(); ++pos) {
									    	Symbol sym = reverse.symbolAt(pos);
											if (sym == DNATools.g() || sym == DNATools.c())
											    ++gc;
									    }
									    Double gc_content = ((gc * 100.0) / reverse.length());
										//buffer.append(seqString);
										//buffer.append('\t');
//										buffer.append(gc_content.toString());
//										buffer.append('\t');
										mean_seq3gc = (((j)*mean_seq3gc)+gc_content)/(j+1);
										
										int ac = 0;
									    for (int pos = 1; pos <= reverse.length(); ++pos) {
									    	Symbol sym = reverse.symbolAt(pos);
											if (sym == DNATools.a() || sym == DNATools.c())
											    ++ac;
									    }
									    Double ac_content = ((ac * 100.0) / reverse.length());
//										buffer.append(ac_content.toString());
//										buffer.append('\t');
										mean_seq3ac = (((j)*mean_seq3ac)+ac_content)/(j+1);

										int ag = 0;
									    for (int pos = 1; pos <= reverse.length(); ++pos) {
									    	Symbol sym = reverse.symbolAt(pos);
											if (sym == DNATools.a() || sym == DNATools.g())
											    ++ag;
									    }
									    Double ag_content = ((ag * 100.0) / reverse.length());
//										buffer.append(ag_content.toString());
//										buffer.append('\t');
										mean_seq3ag = (((j)*mean_seq3ag)+ag_content)/(j+1);

										int at = 0;
									    for (int pos = 1; pos <= reverse.length(); ++pos) {
									    	Symbol sym = reverse.symbolAt(pos);
											if (sym == DNATools.a() || sym == DNATools.t())
											    ++at;
									    }
									    Double at_content = ((at * 100.0) / reverse.length());
//										buffer.append(at_content.toString());
//										buffer.append('\t');
										mean_seq3at = (((j)*mean_seq3at)+at_content)/(j+1);

										int gt = 0;
									    for (int pos = 1; pos <= reverse.length(); ++pos) {
									    	Symbol sym = reverse.symbolAt(pos);
											if (sym == DNATools.g() || sym == DNATools.t())
											    ++gt;
									    }
									    Double gt_content = ((gt * 100.0) / reverse.length());
//										buffer.append(gt_content.toString());
//										buffer.append('\t');
										mean_seq3gt = (((j)*mean_seq3gt)+gt_content)/(j+1);


										int ct = 0;
									    for (int pos = 1; pos <= reverse.length(); ++pos) {
									    	Symbol sym = reverse.symbolAt(pos);
											if (sym == DNATools.c() || sym == DNATools.t())
											    ++ct;
									    }
									    Double ct_content = ((ct * 100.0) / reverse.length());
//										buffer.append(ct_content.toString());
//										buffer.append('\t');
										mean_seq3ct = (((j)*mean_seq3ct)+ct_content)/(j+1);
										
										Double ratio_a_t = a_content/t_content;
//										buffer.append(ratio_a_t.toString());
//										buffer.append('\t');
										mean_seq3ratio_at = (((j)*mean_seq3ratio_at)+ratio_a_t)/(j+1);

										Double ratio_a_g = a_content/g_content;
//										buffer.append(ratio_a_g.toString());
//										buffer.append('\t');
										mean_seq3ratio_ag = (((j)*mean_seq3ratio_ag)+ratio_a_g)/(j+1);

										Double ratio_a_c = a_content/c_content;
//										buffer.append(ratio_a_c.toString());
//										buffer.append('\t');
										mean_seq3ratio_ac = (((j)*mean_seq3ratio_ac)+ratio_a_c)/(j+1);

										Double ratio_t_g = t_content/g_content;
//										buffer.append(ratio_t_g.toString());
//										buffer.append('\t');
										mean_seq3ratio_tg = (((j)*mean_seq3ratio_tg)+ratio_t_g)/(j+1);

										Double ratio_t_c = t_content/c_content;
//										buffer.append(ratio_t_c.toString());
//										buffer.append('\t');
										mean_seq3ratio_tc = (((j)*mean_seq3ratio_tc)+ratio_t_c)/(j+1);

										Double ratio_g_c = g_content/c_content;
//										buffer.append(ratio_g_c.toString());
//										buffer.append('\t');
										mean_seq3ratio_gc = (((j)*mean_seq3ratio_gc)+ratio_g_c)/(j+1);

										Double ratio_at_gc = at_content/gc_content;
//										buffer.append(ratio_at_gc.toString());
//										buffer.append('\t');
										mean_seq3ratio_at_gc = (((j)*mean_seq3ratio_at_gc)+ratio_at_gc)/(j+1);

										Double ratio_ac_gt = ac_content/gt_content;
//										buffer.append(ratio_ac_gt.toString());
//										buffer.append('\t');
										mean_seq3ratio_ac_gt = (((j)*mean_seq3ratio_ac_gt)+ratio_ac_gt)/(j+1);

										Double ratio_ag_ct = ag_content/ct_content;
//										buffer.append(ratio_ag_ct.toString());
//										buffer.append('\t');
										mean_seq3ratio_ag_ct = (((j)*mean_seq3ratio_ag_ct)+ratio_ag_ct)/(j+1);

										Double ratio_a_gt = a_content/gt_content;
//										buffer.append(ratio_a_gt.toString());
//										buffer.append('\t');
										mean_seq3ratio_a_gt = (((j)*mean_seq3ratio_a_gt)+ratio_a_gt)/(j+1);

										Double ratio_a_gc = a_content/gc_content;
//										buffer.append(ratio_a_gc.toString());
//										buffer.append('\t');
										mean_seq3ratio_a_gc = (((j)*mean_seq3ratio_a_gc)+ratio_a_gc)/(j+1);

										Double ratio_a_ct = a_content/ct_content;
//										buffer.append(ratio_a_ct.toString());
//										buffer.append('\t');
										mean_seq3ratio_a_ct = (((j)*mean_seq3ratio_a_ct)+ratio_a_ct)/(j+1);

										Double ratio_t_ag = t_content/ag_content;
//										buffer.append(ratio_t_ag.toString());
//										buffer.append('\t');
										mean_seq3ratio_t_ag = (((j)*mean_seq3ratio_t_ag)+ratio_t_ag)/(j+1);										
										
										Double ratio_t_gc = t_content/gc_content;
//										buffer.append(ratio_t_gc.toString());
//										buffer.append('\t');
										mean_seq3ratio_t_gc = (((j)*mean_seq3ratio_t_gc)+ratio_t_gc)/(j+1);										

										Double ratio_t_ac = t_content/ac_content;
//										buffer.append(ratio_t_ac.toString());
//										buffer.append('\t');
										mean_seq3ratio_t_ac = (((j)*mean_seq3ratio_t_ac)+ratio_t_ac)/(j+1);										

										Double ratio_g_at = g_content/at_content;
//										buffer.append(ratio_g_at.toString());
//										buffer.append('\t');
										mean_seq3ratio_g_at = (((j)*mean_seq3ratio_g_at)+ratio_g_at)/(j+1);										

										Double ratio_g_ac = g_content/ac_content;
//										buffer.append(ratio_g_ac.toString());
//										buffer.append('\t');
										mean_seq3ratio_g_ac = (((j)*mean_seq3ratio_g_ac)+ratio_g_ac)/(j+1);										

										Double ratio_g_ct = g_content/ct_content;
//										buffer.append(ratio_g_ct.toString());
//										buffer.append('\t');
										mean_seq3ratio_g_ct = (((j)*mean_seq3ratio_g_ct)+ratio_g_ct)/(j+1);										

										Double ratio_c_at = c_content/at_content;
//										buffer.append(ratio_c_at.toString());
//										buffer.append('\t');
										mean_seq3ratio_c_at = (((j)*mean_seq3ratio_c_at)+ratio_c_at)/(j+1);										

										Double ratio_c_ag = c_content/ag_content;
//										buffer.append(ratio_c_ag.toString());
//										buffer.append('\t');
										mean_seq3ratio_c_ag = (((j)*mean_seq3ratio_c_ag)+ratio_c_ag)/(j+1);										

										Double ratio_c_gt = c_content/gt_content;
//										buffer.append(ratio_c_gt.toString());
//										buffer.append('\t');
										mean_seq3ratio_c_gt = (((j)*mean_seq3ratio_c_gt)+ratio_c_gt)/(j+1);										

										int aa = 0;
									    for (int pos = 1; pos <= reverse.length()-1; ++pos) {
									    	String sym = reverse.subStr(pos, pos+1);
											if (sym.equals("AA"))
											    ++aa;
									    }
									    
									    Double a_a_content = ((aa * 100.0) / reverse.length());
//										buffer.append(a_a_content.toString());
//										buffer.append('\t');
										mean_seq3a_a = (((j)*mean_seq3a_a)+a_a_content)/(j+1);
										
										int a_t = 0;
									    for (int pos = 1; pos <= reverse.length()-1; ++pos) {
									    	String sym = reverse.subStr(pos, pos+1);
											if (sym.equals("AT"))
											    ++a_t;
									    }
									    
									    Double a_t_content = ((a_t * 100.0) / reverse.length());
//										buffer.append(a_t_content.toString());
//										buffer.append('\t');
										mean_seq3a_t = (((j)*mean_seq3a_t)+a_t_content)/(j+1);
										
										int a_g = 0;
									    for (int pos = 1; pos <= reverse.length()-1; ++pos) {
									    	String sym = reverse.subStr(pos, pos+1);
											if (sym.equals("AG"))
											    ++a_g;
									    }
									    
									    Double a_g_content = ((a_g * 100.0) / reverse.length());
//										buffer.append(a_g_content.toString());
//										buffer.append('\t');
										mean_seq3a_g = (((j)*mean_seq3a_g)+a_g_content)/(j+1);
										
										int a_c = 0;
									    for (int pos = 1; pos <= reverse.length()-1; ++pos) {
									    	String sym = reverse.subStr(pos, pos+1);
											if (sym.equals("AC"))
											    ++a_c;
									    }
									    
									    Double a_c_content = ((a_c * 100.0) / reverse.length());
//										buffer.append(a_c_content.toString());
//										buffer.append('\t');
										mean_seq3a_c = (((j)*mean_seq3a_c)+a_c_content)/(j+1);
										
										int t_t = 0;
									    for (int pos = 1; pos <= reverse.length()-1; ++pos) {
									    	String sym = reverse.subStr(pos, pos+1);
											if (sym.equals("TT"))
											    ++t_t;
									    }
									    
									    Double t_t_content = ((t_t * 100.0) / reverse.length());
//										buffer.append(t_t_content.toString());
//										buffer.append('\t');
										mean_seq3t_t = (((j)*mean_seq3t_t)+t_t_content)/(j+1);
										
										int t_g = 0;
									    for (int pos = 1; pos <= reverse.length()-1; ++pos) {
									    	String sym = reverse.subStr(pos, pos+1);
											if (sym.equals("TG"))
											    ++t_g;
									    }
									    
									    Double t_g_content = ((t_g * 100.0) / reverse.length());
//										buffer.append(t_g_content.toString());
//										buffer.append('\t');
										mean_seq3t_g = (((j)*mean_seq3t_g)+t_g_content)/(j+1);
										
										int t_c = 0;
									    for (int pos = 1; pos <= reverse.length()-1; ++pos) {
									    	String sym = reverse.subStr(pos, pos+1);
											if (sym.equals("TC"))
											    ++t_c;
									    }
									    
									    Double t_c_content = ((t_c * 100.0) / reverse.length());
//										buffer.append(t_c_content.toString());
//										buffer.append('\t');
										mean_seq3t_c = (((j)*mean_seq3t_c)+t_c_content)/(j+1);
										
										int g_g = 0;
									    for (int pos = 1; pos <= reverse.length()-1; ++pos) {
									    	String sym = reverse.subStr(pos, pos+1);
											if (sym.equals("GG"))
											    ++g_g;
									    }
									    
									    Double g_g_content = ((g_g * 100.0) / reverse.length());
//										buffer.append(g_g_content.toString());
//										buffer.append('\t');
										mean_seq3g_g = (((j)*mean_seq3g_g)+g_g_content)/(j+1);
										
										int g_c = 0;
									    for (int pos = 1; pos <= reverse.length()-1; ++pos) {
									    	String sym = reverse.subStr(pos, pos+1);
											if (sym.equals("GC"))
											    ++g_c;
									    }
									    
									    Double g_c_content = ((g_c * 100.0) / reverse.length());
//										buffer.append(g_c_content.toString());
//										buffer.append('\t');
										mean_seq3g_c = (((j)*mean_seq3g_c)+g_c_content)/(j+1);
										
										int c_c = 0;
									    for (int pos = 1; pos <= reverse.length()-1; ++pos) {
									    	String sym = reverse.subStr(pos, pos+1);
											if (sym.equals("CC"))
											    ++c_c;
									    }
									    
									    Double c_c_content = ((c_c * 100.0) / reverse.length());
//										buffer.append(c_c_content.toString());
//										buffer.append('\t');
										mean_seq3c_c = (((j)*mean_seq3c_c)+c_c_content)/(j+1);
									
										int aa_a = 0;
									    for (int pos = 1; pos <= reverse.length()-2; ++pos) {
									    	String sym = reverse.subStr(pos, pos+2);
											if (sym.equals("AAA"))
											    ++aa_a;
									    }
									    
									    Double aa_a_content = ((aa_a * 100.0) / reverse.length());
//										buffer.append(aa_a_content.toString());
//										buffer.append('\t');
										mean_seq3aa_a = (((j)*mean_seq3aa_a)+aa_a_content)/(j+1);
										
										
										int aa_t = 0;
									    for (int pos = 1; pos <= reverse.length()-2; ++pos) {
									    	String sym = reverse.subStr(pos, pos+2);
											if (sym.equals("AAT"))
											    ++aa_t;
									    }
									    
									    Double aa_t_content = ((aa_t * 100.0) / reverse.length());
//										buffer.append(aa_t_content.toString());
//										buffer.append('\t');
										mean_seq3aa_t = (((j)*mean_seq3aa_t)+aa_t_content)/(j+1);
										
										int aa_g = 0;
									    for (int pos = 1; pos <= reverse.length()-2; ++pos) {
									    	String sym = reverse.subStr(pos, pos+2);
											if (sym.equals("AAG"))
											    ++aa_g;
									    }
									    
									    Double aa_g_content = ((aa_g * 100.0) / reverse.length());
//										buffer.append(aa_g_content.toString());
//										buffer.append('\t');
										mean_seq3aa_g = (((j)*mean_seq3aa_g)+aa_g_content)/(j+1);
										
										int aa_c = 0;
									    for (int pos = 1; pos <= reverse.length()-2; ++pos) {
									    	String sym = reverse.subStr(pos, pos+2);
											if (sym.equals("AAC"))
											    ++aa_c;
									    }
									    
									    Double aa_c_content = ((aa_c * 100.0) / reverse.length());
//										buffer.append(aa_c_content.toString());
//										buffer.append('\t');
										mean_seq3aa_c = (((j)*mean_seq3aa_c)+aa_c_content)/(j+1);
										
										int tt_a = 0;
									    for (int pos = 1; pos <= reverse.length()-2; ++pos) {
									    	String sym = reverse.subStr(pos, pos+2);
											if (sym.equals("TTA"))
											    ++tt_a;
									    }
									    
									    Double tt_a_content = ((tt_a * 100.0) / reverse.length());
//										buffer.append(tt_a_content.toString());
//										buffer.append('\t');
										mean_seq3tt_a = (((j)*mean_seq3tt_a)+tt_a_content)/(j+1);
										
										int tt_t = 0;
									    for (int pos = 1; pos <= reverse.length()-2; ++pos) {
									    	String sym = reverse.subStr(pos, pos+2);
											if (sym.equals("TTT"))
											    ++tt_t;
									    }
									    
									    Double tt_t_content = ((tt_t * 100.0) / reverse.length());
//										buffer.append(tt_t_content.toString());
//										buffer.append('\t');
										mean_seq3tt_t = (((j)*mean_seq3tt_t)+tt_t_content)/(j+1);
										
										int tt_g = 0;
									    for (int pos = 1; pos <= reverse.length()-2; ++pos) {
									    	String sym = reverse.subStr(pos, pos+2);
											if (sym.equals("TTG"))
											    ++tt_g;
									    }
									    
									    Double tt_g_content = ((tt_g * 100.0) / reverse.length());
//										buffer.append(tt_g_content.toString());
//										buffer.append('\t');
										mean_seq3tt_g = (((j)*mean_seq3tt_g)+tt_g_content)/(j+1);
										
										int tt_c = 0;
									    for (int pos = 1; pos <= reverse.length()-2; ++pos) {
									    	String sym = reverse.subStr(pos, pos+2);
											if (sym.equals("TTC"))
											    ++tt_c;
									    }
									    
									    Double tt_c_content = ((tt_c * 100.0) / reverse.length());
//										buffer.append(tt_c_content.toString());
//										buffer.append('\t');
										mean_seq3tt_c = (((j)*mean_seq3tt_c)+tt_c_content)/(j+1);
										
										int gg_a = 0;
									    for (int pos = 1; pos <= reverse.length()-2; ++pos) {
									    	String sym = reverse.subStr(pos, pos+2);
											if (sym.equals("GGA"))
											    ++gg_a;
									    }
									    
									    Double gg_a_content = ((gg_a * 100.0) / reverse.length());
//										buffer.append(gg_a_content.toString());
//										buffer.append('\t');
										mean_seq3gg_a = (((j)*mean_seq3gg_a)+gg_a_content)/(j+1);
										
										int gg_t = 0;
									    for (int pos = 1; pos <= reverse.length()-2; ++pos) {
									    	String sym = reverse.subStr(pos, pos+2);
											if (sym.equals("GGT"))
											    ++gg_t;
									    }
									    
									    Double gg_t_content = ((gg_t * 100.0) / reverse.length());
//										buffer.append(gg_t_content.toString());
//										buffer.append('\t');
										mean_seq3gg_t = (((j)*mean_seq3gg_t)+gg_t_content)/(j+1);
										
										int gg_g = 0;
									    for (int pos = 1; pos <= reverse.length()-2; ++pos) {
									    	String sym = reverse.subStr(pos, pos+2);
											if (sym.equals("GGG"))
											    ++gg_g;
									    }
									    
									    Double gg_g_content = ((gg_g * 100.0) / reverse.length());
//										buffer.append(gg_g_content.toString());
//										buffer.append('\t');
										mean_seq3gg_g = (((j)*mean_seq3gg_g)+gg_g_content)/(j+1);
										
										int gg_c = 0;
									    for (int pos = 1; pos <= reverse.length()-2; ++pos) {
									    	String sym = reverse.subStr(pos, pos+2);
											if (sym.equals("GGC"))
											    ++gg_c;
									    }
									    
									    Double gg_c_content = ((gg_c * 100.0) / reverse.length());
//										buffer.append(gg_c_content.toString());
//										buffer.append('\t');
										mean_seq3gg_c = (((j)*mean_seq3gg_c)+gg_c_content)/(j+1);
										
										int cc_a = 0;
									    for (int pos = 1; pos <= reverse.length()-2; ++pos) {
									    	String sym = reverse.subStr(pos, pos+2);
											if (sym.equals("CCA"))
											    ++cc_a;
									    }
									    
									    Double cc_a_content = ((cc_a * 100.0) / reverse.length());
//										buffer.append(cc_a_content.toString());
//										buffer.append('\t');
										mean_seq3cc_a = (((j)*mean_seq3cc_a)+cc_a_content)/(j+1);
										
										int cc_t = 0;
									    for (int pos = 1; pos <= reverse.length()-2; ++pos) {
									    	String sym = reverse.subStr(pos, pos+2);
											if (sym.equals("CCT"))
											    ++cc_t;
									    }
									    
									    Double cc_t_content = ((cc_t * 100.0) / reverse.length());
//										buffer.append(cc_t_content.toString());
//										buffer.append('\t');
										mean_seq3cc_t = (((j)*mean_seq3cc_t)+cc_t_content)/(j+1);
										
										int cc_g = 0;
									    for (int pos = 1; pos <= reverse.length()-2; ++pos) {
									    	String sym = reverse.subStr(pos, pos+2);
											if (sym.equals("CCG"))
											    ++cc_g;
									    }
									    
									    Double cc_g_content = ((cc_g * 100.0) / reverse.length());
//										buffer.append(cc_g_content.toString());
//										buffer.append('\t');
										mean_seq3cc_g = (((j)*mean_seq3cc_g)+cc_g_content)/(j+1);
										
										int cc_c = 0;
									    for (int pos = 1; pos <= reverse.length()-2; ++pos) {
									    	String sym = reverse.subStr(pos, pos+2);
											if (sym.equals("CCC"))
											    ++cc_c;
									    }
									    
									    Double cc_c_content = ((cc_c * 100.0) / reverse.length());
//										buffer.append(cc_c_content.toString());
//										buffer.append('\t');
										mean_seq3cc_c = (((j)*mean_seq3cc_c)+cc_c_content)/(j+1);
									}
								}
							}
// bonds among sequences
							for (Integer val5 : seq5map.values()){
								String seq5 = seq5map_rev.get(val5);
								String seq3 = seq3map_rev.get(val5);
								int a = 0;						//watson-crick bonds
								int b = 0;						//other purine-pyrimidine bonds
								int c = 0;						//purine-purine and pyrimidine-pyrimidine bonds
								int d = 0;						//purine-purine and pyrimidine-pyrimidine bonds (this time each base with itself)
								Integer seq5purineSum = 0;
								Integer seq5pyrimidineSum = 0;
								Integer seq3purineSum = 0;
								Integer seq3pyrimidineSum = 0;
								int length = 0;
								if (seq5.length()==seq3.length()){//to avoid possible errors in the xml.... one way or another a good statistic is going to be in the output
									length=seq5.length();
								}
								else if (seq5.length() < seq3.length()){
									length=seq5.length();
								}
								else if (seq5.length() > seq3.length()){
									length=seq3.length();
								}
								for (int pos = 0; pos < length; ++pos) {
							    	Character seq5char = seq5.charAt(pos);
							    	Character seq3char = seq3.charAt(pos);
									if ((seq5char  == 'A' && seq3char == 'T') || (seq5char  == 'T' && seq3char == 'A') || (seq5char  == 'G' && seq3char == 'C') || (seq5char  == 'C' && seq3char == 'G'))
									    ++a;
									else if ((seq5char  == 'A' && seq3char == 'C') || (seq5char  == 'C' && seq3char == 'A') || (seq5char  == 'G' && seq3char == 'T') || (seq5char  == 'T' && seq3char == 'G'))
									    ++b;
									else if ((seq5char  == 'A' && seq3char == 'G') || (seq5char  == 'G' && seq3char == 'A') || (seq5char  == 'T' && seq3char == 'C') || (seq5char  == 'C' && seq3char == 'T'))
									    ++c;
									else if ((seq5char  == 'A' && seq3char == 'A') || (seq5char  == 'G' && seq3char == 'G') || (seq5char  == 'T' && seq3char == 'T') || (seq5char  == 'C' && seq3char == 'C'))
									    ++d;
									if (seq5char  == 'A' || seq5char  == 'G')
									    ++seq5pyrimidineSum;
									else if (seq5char  == 'T' || seq5char  == 'C')
									    ++seq5purineSum;
									if (seq3char  == 'A' || seq3char  == 'G')
									    ++seq3pyrimidineSum;
									else if (seq3char  == 'T' || seq3char  == 'C')
									    ++seq3purineSum;
							    }
							    Double a_bonds = ((a * 100.0) / length);
								mean_a_bonds = (((j)*mean_a_bonds)+a_bonds)/(j+1);
//								buffer.append(a_bonds.toString());
//								buffer.append('\t');
							    Double b_bonds = ((b * 100.0) / length);
								mean_b_bonds = (((j)*mean_b_bonds)+b_bonds)/(j+1);
//								buffer.append(b_bonds.toString());
//								buffer.append('\t');
							    Double c_bonds = ((c * 100.0) / length);
								mean_c_bonds = (((j)*mean_c_bonds)+c_bonds)/(j+1);
//								buffer.append(c_bonds.toString());
//								buffer.append('\t');
							    Double d_bonds = ((d * 100.0) / length);
								mean_d_bonds = (((j)*mean_d_bonds)+d_bonds)/(j+1);
//								buffer.append(d_bonds.toString());
//								buffer.append('\t');

								mean_seq5pyrimidineSum = (((j)*mean_seq5pyrimidineSum)+seq5pyrimidineSum)/(j+1);
//								buffer.append(seq5pyrimidineSum.toString());
//								buffer.append('\t');
								mean_seq5purineSum = (((j)*mean_seq5purineSum)+seq5purineSum)/(j+1);
//								buffer.append(seq5purineSum.toString());
//								buffer.append('\t');
								mean_seq3pyrimidineSum = (((j)*mean_seq3pyrimidineSum)+seq3pyrimidineSum)/(j+1);
//								buffer.append(seq3pyrimidineSum.toString());
//								buffer.append('\t');
								mean_seq3purineSum = (((j)*mean_seq3purineSum)+seq3purineSum)/(j+1);
//								buffer.append(seq3purineSum.toString());
//								buffer.append('\t');
							}
						}
					}
					if (mean_subSnpClass > 0.5){
						buffer.append("1");
						buffer.append('\t');
					}
					else{
						buffer.append("0");
						buffer.append('\t');						
					}
					if (mean_orient > 0.5){
						buffer.append("1");
						buffer.append('\t');
					}
					else{
						buffer.append("0");
						buffer.append('\t');						
					}
					if (mean_strand > 0.5){
						buffer.append("1");
						buffer.append('\t');
					}
					else{
						buffer.append("0");
						buffer.append('\t');						
					}
					if (mean_molType > 0.5){
						buffer.append("1");
						buffer.append('\t');
					}
					else{
						buffer.append("0");
						buffer.append('\t');						
					}
					if (mean_methodClass > 0.5){
						buffer.append("1");
						buffer.append('\t');
					}
					else{
						buffer.append("0");
						buffer.append('\t');						
					}
					if (mean_validated > 0.5){
						buffer.append("1");
						buffer.append('\t');
					}
					else{
						buffer.append("0");
						buffer.append('\t');						
					}
					if (seq5map.get(seq5String)!=null){
						buffer.append(seq5map.get(seq5String).toString());
						buffer.append('\t');				
					}			
					else {
						buffer.append("0");
						buffer.append('\t');				
					}
					buffer.append(mean_seq5a.toString());
					buffer.append('\t');							
					buffer.append(mean_seq5t.toString());
					buffer.append('\t');
					buffer.append(mean_seq5g.toString());
					buffer.append('\t');
					buffer.append(mean_seq5c.toString());
					buffer.append('\t');
					buffer.append(mean_seq5gc.toString());
					buffer.append('\t');
					buffer.append(mean_seq5ac.toString());
					buffer.append('\t');
					buffer.append(mean_seq5ag.toString());
					buffer.append('\t');
					buffer.append(mean_seq5at.toString());
					buffer.append('\t');
					buffer.append(mean_seq5gt.toString());
					buffer.append('\t');
					buffer.append(mean_seq5ct.toString());
					buffer.append('\t');
					buffer.append(mean_seq5ratio_at.toString());
					buffer.append('\t');
					buffer.append(mean_seq5ratio_ag.toString());
					buffer.append('\t');
					buffer.append(mean_seq5ratio_ac.toString());
					buffer.append('\t');
					buffer.append(mean_seq5ratio_tg.toString());
					buffer.append('\t');
					buffer.append(mean_seq5ratio_tc.toString());
					buffer.append('\t');
					buffer.append(mean_seq5ratio_gc.toString());
					buffer.append('\t');
					buffer.append(mean_seq5ratio_at_gc.toString());
					buffer.append('\t');
					buffer.append(mean_seq5ratio_ac_gt.toString());
					buffer.append('\t');
					buffer.append(mean_seq5ratio_ag_ct.toString());
					buffer.append('\t');
					buffer.append(mean_seq5ratio_a_gt.toString());
					buffer.append('\t');
					buffer.append(mean_seq5ratio_a_gc.toString());
					buffer.append('\t');
					buffer.append(mean_seq5ratio_a_ct.toString());
					buffer.append('\t');
					buffer.append(mean_seq5ratio_t_ag.toString());
					buffer.append('\t');
					buffer.append(mean_seq5ratio_t_gc.toString());
					buffer.append('\t');
					buffer.append(mean_seq5ratio_t_ac.toString());
					buffer.append('\t');
					buffer.append(mean_seq5ratio_g_at.toString());
					buffer.append('\t');
					buffer.append(mean_seq5ratio_g_ac.toString());
					buffer.append('\t');
					buffer.append(mean_seq5ratio_g_ct.toString());
					buffer.append('\t');
					buffer.append(mean_seq5ratio_c_at.toString());
					buffer.append('\t');
					buffer.append(mean_seq5ratio_c_ag.toString());
					buffer.append('\t');
					buffer.append(mean_seq5ratio_c_gt.toString());
					buffer.append('\t');
					buffer.append(mean_seq5a_a.toString());
					buffer.append('\t');
					buffer.append(mean_seq5a_t.toString());
					buffer.append('\t');
					buffer.append(mean_seq5a_g.toString());
					buffer.append('\t');
					buffer.append(mean_seq5a_c.toString());
					buffer.append('\t');
					buffer.append(mean_seq5t_t.toString());
					buffer.append('\t');
					buffer.append(mean_seq5t_g.toString());
					buffer.append('\t');
					buffer.append(mean_seq5t_c.toString());
					buffer.append('\t');
					buffer.append(mean_seq5g_g.toString());
					buffer.append('\t');
					buffer.append(mean_seq5g_c.toString());
					buffer.append('\t');
					buffer.append(mean_seq5c_c.toString());
					buffer.append('\t');
					buffer.append(mean_seq5aa_a.toString());
					buffer.append('\t');
					buffer.append(mean_seq5aa_t.toString());
					buffer.append('\t');
					buffer.append(mean_seq5aa_g.toString());
					buffer.append('\t');
					buffer.append(mean_seq5aa_c.toString());
					buffer.append('\t');
					buffer.append(mean_seq5tt_a.toString());
					buffer.append('\t');
					buffer.append(mean_seq5tt_t.toString());
					buffer.append('\t');
					buffer.append(mean_seq5tt_g.toString());
					buffer.append('\t');
					buffer.append(mean_seq5tt_c.toString());
					buffer.append('\t');
					buffer.append(mean_seq5gg_a.toString());
					buffer.append('\t');
					buffer.append(mean_seq5gg_t.toString());
					buffer.append('\t');
					buffer.append(mean_seq5gg_g.toString());
					buffer.append('\t');
					buffer.append(mean_seq5gg_c.toString());
					buffer.append('\t');
					buffer.append(mean_seq5cc_a.toString());
					buffer.append('\t');
					buffer.append(mean_seq5cc_t.toString());
					buffer.append('\t');
					buffer.append(mean_seq5cc_g.toString());
					buffer.append('\t');
					buffer.append(mean_seq5cc_c.toString());
					buffer.append('\t');
					buffer.append(mostObs.toString());
					buffer.append('\t');
					if (seq3map.get(seq3String)!=null){
						buffer.append(seq3map.get(seq3String).toString());
						buffer.append('\t');							
					}
					else {
						buffer.append("0");
						buffer.append('\t');							
					}
					buffer.append(mean_seq3a.toString());
					buffer.append('\t');							
					buffer.append(mean_seq3t.toString());
					buffer.append('\t');
					buffer.append(mean_seq3g.toString());
					buffer.append('\t');
					buffer.append(mean_seq3c.toString());
					buffer.append('\t');
					buffer.append(mean_seq3gc.toString());
					buffer.append('\t');
					buffer.append(mean_seq3ac.toString());
					buffer.append('\t');
					buffer.append(mean_seq3ag.toString());
					buffer.append('\t');
					buffer.append(mean_seq3at.toString());
					buffer.append('\t');
					buffer.append(mean_seq3gt.toString());
					buffer.append('\t');
					buffer.append(mean_seq3ct.toString());
					buffer.append('\t');
					buffer.append(mean_seq3ratio_at.toString());
					buffer.append('\t');
					buffer.append(mean_seq3ratio_ag.toString());
					buffer.append('\t');
					buffer.append(mean_seq3ratio_ac.toString());
					buffer.append('\t');
					buffer.append(mean_seq3ratio_tg.toString());
					buffer.append('\t');
					buffer.append(mean_seq3ratio_tc.toString());
					buffer.append('\t');
					buffer.append(mean_seq3ratio_gc.toString());
					buffer.append('\t');
					buffer.append(mean_seq3ratio_at_gc.toString());
					buffer.append('\t');
					buffer.append(mean_seq3ratio_ac_gt.toString());
					buffer.append('\t');
					buffer.append(mean_seq3ratio_ag_ct.toString());
					buffer.append('\t');
					buffer.append(mean_seq3ratio_a_gt.toString());
					buffer.append('\t');
					buffer.append(mean_seq3ratio_a_gc.toString());
					buffer.append('\t');
					buffer.append(mean_seq3ratio_a_ct.toString());
					buffer.append('\t');
					buffer.append(mean_seq3ratio_t_ag.toString());
					buffer.append('\t');
					buffer.append(mean_seq3ratio_t_gc.toString());
					buffer.append('\t');
					buffer.append(mean_seq3ratio_t_ac.toString());
					buffer.append('\t');
					buffer.append(mean_seq3ratio_g_at.toString());
					buffer.append('\t');
					buffer.append(mean_seq3ratio_g_ac.toString());
					buffer.append('\t');
					buffer.append(mean_seq3ratio_g_ct.toString());
					buffer.append('\t');
					buffer.append(mean_seq3ratio_c_at.toString());
					buffer.append('\t');
					buffer.append(mean_seq3ratio_c_ag.toString());
					buffer.append('\t');
					buffer.append(mean_seq3ratio_c_gt.toString());
					buffer.append('\t');
					buffer.append(mean_seq3a_a.toString());
					buffer.append('\t');
					buffer.append(mean_seq3a_t.toString());
					buffer.append('\t');
					buffer.append(mean_seq3a_g.toString());
					buffer.append('\t');
					buffer.append(mean_seq3a_c.toString());
					buffer.append('\t');
					buffer.append(mean_seq3t_t.toString());
					buffer.append('\t');
					buffer.append(mean_seq3t_g.toString());
					buffer.append('\t');
					buffer.append(mean_seq3t_c.toString());
					buffer.append('\t');
					buffer.append(mean_seq3g_g.toString());
					buffer.append('\t');
					buffer.append(mean_seq3g_c.toString());
					buffer.append('\t');
					buffer.append(mean_seq3c_c.toString());
					buffer.append('\t');
					buffer.append(mean_seq3aa_a.toString());
					buffer.append('\t');
					buffer.append(mean_seq3aa_t.toString());
					buffer.append('\t');
					buffer.append(mean_seq3aa_g.toString());
					buffer.append('\t');
					buffer.append(mean_seq3aa_c.toString());
					buffer.append('\t');
					buffer.append(mean_seq3tt_a.toString());
					buffer.append('\t');
					buffer.append(mean_seq3tt_t.toString());
					buffer.append('\t');
					buffer.append(mean_seq3tt_g.toString());
					buffer.append('\t');
					buffer.append(mean_seq3tt_c.toString());
					buffer.append('\t');
					buffer.append(mean_seq3gg_a.toString());
					buffer.append('\t');
					buffer.append(mean_seq3gg_t.toString());
					buffer.append('\t');
					buffer.append(mean_seq3gg_g.toString());
					buffer.append('\t');
					buffer.append(mean_seq3gg_c.toString());
					buffer.append('\t');
					buffer.append(mean_seq3cc_a.toString());
					buffer.append('\t');
					buffer.append(mean_seq3cc_t.toString());
					buffer.append('\t');
					buffer.append(mean_seq3cc_g.toString());
					buffer.append('\t');
					buffer.append(mean_seq3cc_c.toString());
					buffer.append('\t');
					buffer.append(mean_a_bonds.toString());
					buffer.append('\t');
					buffer.append(mean_b_bonds.toString());
					buffer.append('\t');
					buffer.append(mean_c_bonds.toString());
					buffer.append('\t');
					buffer.append(mean_d_bonds.toString());
					buffer.append('\t');
					buffer.append(mean_seq5pyrimidineSum.toString());
					buffer.append('\t');
					buffer.append(mean_seq5purineSum.toString());
					buffer.append('\t');
					buffer.append(mean_seq3pyrimidineSum.toString());
					buffer.append('\t');
					buffer.append(mean_seq3purineSum.toString());
					buffer.append('\t');
				}
//end of Ss
//start of Assembly
				NodeList nl1_4 = el.getElementsByTagName("Assembly");
				if (nl1_4 != null && nl1_4.getLength() > 0) {
					String mean_groupLabel = null;
					Double mean_componentType = 0.0;
					String mean_accession = null;
					String mean_chromosome = null;
					Double mean_start = 0.0;
					Double mean_end = 0.0;
					Double mean_length = 0.0;
					Double mean_orientation = 0.0;
					String mean_gi = null;
					String mean_groupTerm = null;
					String mean_contigLabel = null;
					Double mean_locType = 0.0;
					Double mean_alnQuality = 0.0;
					Double mean_orient = 0.0;
					String mean_geneId = null;
					String mean_symbol = null;
					Double mean_mrnaVer = 0.0;
					Double mean_protVer = 0.0;
					Double mean_fnxClass = 0.0;
					Double mean_readingFrame = 0.0;
					Double mean_aaPosition = 0.0;
					Double mean_chromCount = 0.0;
					Double mean_placedContigCount = 0.0;
					Double mean_unplacedContigCount = 0.0;
					Double mean_seqLocCount = 0.0;
					Double mean_hapCount = 0.0;
					int refAlleleA=0;
					int refAlleleT=0;
					int refAlleleG=0;
					int refAlleleC=0;
					int maxRefAllele=0;
					Integer mostRefAllele=0;
					int fnxRefAlleleA=0;
					int fnxRefAlleleT=0;
					int fnxRefAlleleG=0;
					int fnxRefAlleleC=0;
					int	maxFnxRefAllele=0;
					Integer mostFnxRefAllele=0;
					int fnxResidueA=0;
					int fnxResidueB=0;
					int fnxResidueC=0;
					int fnxResidueD=0;
					int fnxResidueE=0;
					int fnxResidueF=0;
					int fnxResidueG=0;
					int fnxResidueH=0;
					int fnxResidueI=0;
					int fnxResidueK=0;
					int fnxResidueL=0;
					int fnxResidueM=0;
					int fnxResidueN=0;
					int fnxResidueP=0;
					int fnxResidueQ=0;
					int fnxResidueR=0;
					int fnxResidueS=0;
					int fnxResidueT=0;
					int fnxResidueV=0;
					int fnxResidueW=0;
					int fnxResidueX=0;
					int fnxResidueY=0;
					int fnxResidueZ=0;
					int maxFnxResidue=0;
					Integer mostFnxResidue=0;
		

					Element el1 = null;
					for (int j = 0; j < nl1_4.getLength(); j++) {
						// get the "Assembly" element
						if (j>maxAssembly)
							maxAssembly=j;
						el1 = (Element) nl1_4.item(j);
						// WRITE ITEMS
						Integer glid = 1;
						if (glmap.containsKey(el1.getAttribute("groupLabel"))){
//							buffer.append(glmap.get(el1.getAttribute("groupLabel")).toString());
//							buffer.append('\t');							
						}
						else {
							mean_groupLabel = el1.getAttribute("groupLabel");
							glmap.put(el1.getAttribute("groupLabel"), glid);
//							buffer.append(glmap.get(el1.getAttribute("groupLabel")).toString());
//							buffer.append('\t');
							glid++;
						}

						NodeList nl2_1 = el1.getElementsByTagName("Component");
						if (nl2_1 != null && nl2_1.getLength() > 0) {
							for (int k = 0; k < nl2_1.getLength(); k++) {
								// get the "Component" element
								if (k>maxComponent)
									maxComponent=k;
								Element el2 = (Element) nl2_1.item(k);
								if (el2.getAttribute("componentType").equals("contig")){
									mean_componentType = (((j)*mean_componentType)+1)/(j+1);
//									buffer.append("1");
//									buffer.append('\t');									
								}
								else{
									mean_componentType = (((j)*mean_componentType)+0)/(j+1);
//									buffer.append("2");
//									buffer.append('\t');									
								}
								Integer asid = 1;
								if (asmap.containsKey(el2.getAttribute("accession"))){
//									buffer.append(asmap.get(el2.getAttribute("accession")).toString());
//									buffer.append('\t');							
								}
								else {
									mean_accession = el2.getAttribute("accession");
									asmap.put(el2.getAttribute("accession"), asid);
//									buffer.append(asmap.get(el2.getAttribute("accession")).toString());
//									buffer.append('\t');							
									asid++;
								}
								Integer chromid = 1;
								if (chrommap.containsKey(el2.getAttribute("chromosome"))){
//									buffer.append(chrommap.get(el2.getAttribute("chromosome")).toString());
//									buffer.append('\t');							
								}
								else {
									mean_chromosome = el2.getAttribute("chromosome");
									chrommap.put(el2.getAttribute("chromosome"), chromid);
//									buffer.append(chrommap.get(el2.getAttribute("chromosome")).toString());
//									buffer.append('\t');							
									chromid++;
								}				
								Integer start = 0;
								Integer end = 0;
								if(!el2.getAttribute("start").isEmpty() & !el2.getAttribute("end").isEmpty()){
									start = Integer.parseInt(el2.getAttribute("start"));
									end = Integer.parseInt(el2.getAttribute("end"));
								}	
//								buffer.append(start.toString());
//								buffer.append('\t');
//								buffer.append(end.toString());
//								buffer.append('\t');
								mean_start = (((j)*mean_start)+start)/(j+1);
								mean_end = (((j)*mean_end)+end)/(j+1);

								Integer snpLength = 0;
								if (start > 0 && end > 0){
									snpLength = end - start;
//									System.out.println("snp Length ="+snpLength);
								}
								mean_length = (((j)*mean_length)+snpLength)/(j+1);
//								buffer.append(snpLength.toString());
//								buffer.append('\t');

								if (el2.getAttribute("orientation").equals("fwd")){
									mean_orientation = (((j)*mean_orientation)+1)/(j+1);
//									buffer.append("1");
//									buffer.append('\t');									
								}
								else {
									mean_orientation = (((j)*mean_orientation)+0)/(j+1);
//									buffer.append("2");
//									buffer.append('\t');									
								}
								Integer giid = 1;
								if (gimap.containsKey(el.getAttribute("gi"))){
//									buffer.append(gimap.get(el.getAttribute("gi")).toString());
//									buffer.append('\t');							
								}
								else {
									mean_gi = el.getAttribute("gi");
									gimap.put(el.getAttribute("gi"), giid);
//									buffer.append(gimap.get(el.getAttribute("gi")).toString());
//									buffer.append('\t');							
									giid++;
								}
								Integer grtid = 1;
								if (grtmap.containsKey(el.getAttribute("groupTerm"))){
//									buffer.append(grtmap.get(el.getAttribute("groupTerm")).toString());
//									buffer.append('\t');							
								}
								else {
									mean_groupTerm = el.getAttribute("groupTerm");
									grtmap.put(el.getAttribute("groupTerm"), grtid);
//									buffer.append(grtmap.get(el.getAttribute("groupTerm")).toString());
//									buffer.append('\t');							
									grtid++;
								}
								Integer clid = 1;
								if (clmap.containsKey(el.getAttribute("contigLabel"))){
//									buffer.append(clmap.get(el.getAttribute("contigLabel")).toString());
//									buffer.append('\t');							
								}
								else {
									mean_contigLabel = el.getAttribute("contigLabel");
									clmap.put(el.getAttribute("contigLabel"), clid);
//									buffer.append(clmap.get(el.getAttribute("contigLabel")).toString());
//									buffer.append('\t');							
									clid++;
								}
								NodeList nl3_1 = el2.getElementsByTagName("MapLoc");
								if (nl3_1 != null && nl3_1.getLength() > 0) {
									for (int l = 0; l < nl3_1.getLength(); l++) {
										// get the "MapLoc" element
										if(l>maxMapLoc)
											maxMapLoc=l;
										Element el3 = (Element) nl3_1.item(l);
										// WRITE ITEMS
										if (el3.getAttribute("locType").equals("exact")){
											mean_locType = (((j)*mean_locType)+1)/(j+1);
//											buffer.append("1");
//											buffer.append('\t');
										}
										else {	
											mean_locType = (((j)*mean_locType)+0)/(j+1);
//											buffer.append("2");
//											buffer.append('\t');
										}
										mean_alnQuality = (((j)*mean_alnQuality)+Double.parseDouble(el3.getAttribute("alnQuality")))/(j+1);
//										buffer.append(el3.getAttribute("alnQuality"));
//										buffer.append('\t');
										if (el3.getAttribute("orient").equals("forward")){
											mean_orient = (((j)*mean_orient)+1)/(j+1);
//											buffer.append("1");
//											buffer.append('\t');											
										}
										else {											
											mean_orient = (((j)*mean_orient)+0)/(j+1);
//											buffer.append("2");											
//											buffer.append('\t');											
										}
										if (el3.getAttribute("refAllele").equals("A")){
											refAlleleA++;
											if(maxRefAllele<refAlleleA){
												maxRefAllele++;
												mostRefAllele=1;
											}
//											buffer.append("1");
//											buffer.append('\t');
										}
										else if (el3.getAttribute("refAllele").equals("T")){
											refAlleleT++;
											if(maxRefAllele<refAlleleT){
												maxRefAllele++;
												mostRefAllele=2;
											}
//											buffer.append("2");
//											buffer.append('\t');
										}
										else if (el3.getAttribute("refAllele").equals("G")){
											refAlleleG++;
											if(maxRefAllele<refAlleleG){
												maxRefAllele++;
												mostRefAllele=3;
											}
//											buffer.append("3");
//											buffer.append('\t');
										}
										else if (el3.getAttribute("refAllele").equals("C")){
											refAlleleC++;
											if(maxRefAllele<refAlleleC){
												maxRefAllele++;
												mostRefAllele=4;
											}
//											buffer.append("4");
//											buffer.append('\t');
										}

										NodeList nl4_1 = el3.getElementsByTagName("FnxSet");
										if (nl4_1 != null && nl4_1.getLength() > 0) {
											for (int m = 0; m < nl4_1.getLength(); m++) {
												// get the "FnxSet" element
												if(m>maxFxnSet)
													maxFxnSet=m;
												Element el4 = (Element) nl4_1.item(m);
												// WRITE ITEMS
												Integer geneid = 1;
												if (genemap.containsKey(el4.getAttribute("geneId"))){
//													buffer.append(genemap.get(el.getAttribute("geneId")).toString());
//													buffer.append('\t');							
												}
												else {
													mean_geneId = el4.getAttribute("geneId");
													genemap.put(el4.getAttribute("geneId"), geneid);
//													buffer.append(genemap.get(el.getAttribute("geneId")).toString());
//													buffer.append('\t');							
													geneid++;
												}
												Integer symid = 1;
												if (symmap.containsKey(el4.getAttribute("symbol"))){
//													buffer.append(symmap.get(el.getAttribute("symbol")).toString());
//													buffer.append('\t');							
												}
												else {
													mean_symbol = el4.getAttribute("symbol");
													symmap.put(el4.getAttribute("symbol"), symid);
//													buffer.append(symmap.get(el.getAttribute("symbol")).toString());
//													buffer.append('\t');							
													symid++;
												}
												mean_mrnaVer = (((j)*mean_mrnaVer)+Double.parseDouble(el4.getAttribute("mrnaVer")))/(j+1);
//												buffer.append(el4.getAttribute("mrnaVer"));
//												buffer.append('\t');
												mean_protVer = (((j)*mean_protVer)+Double.parseDouble(el4.getAttribute("protVer")))/(j+1);
//												buffer.append(el4.getAttribute("protVer"));
//												buffer.append('\t');
												if (el4.getAttribute("fxnClass").equals("reference")){
													mean_protVer = (((j)*mean_protVer)+1)/(j+1);
//													buffer.append("1");
//													buffer.append('\t');													
												}
												else if (el4.getAttribute("fxnClass").equals("missence")){
													mean_protVer = (((j)*mean_protVer)+2)/(j+1);
													//buffer.append("2");
													//buffer.append('\t');													
												}
												else{
													mean_protVer = (((j)*mean_protVer)+3)/(j+1);
													//buffer.append("3");
													//buffer.append('\t');													
												}
												mean_protVer = (((j)*mean_protVer)+Double.parseDouble(el4.getAttribute("readingFrame")))/(j+1);
												//buffer.append(el4.getAttribute("readingFrame"));
												//buffer.append('\t');
												if (el4.getAttribute("allele").equals("A")){
													fnxRefAlleleA++;
													if(maxFnxRefAllele<fnxRefAlleleA){
														maxFnxRefAllele++;
														mostFnxRefAllele=1;
													}
													//buffer.append("1");
													//buffer.append('\t');
												}
												else if (el4.getAttribute("allele").equals("T")){
													fnxRefAlleleT++;
													if(maxFnxRefAllele<fnxRefAlleleT){
														maxFnxRefAllele++;
														mostFnxRefAllele=2;
													}
													//buffer.append("2");
													//buffer.append('\t');
												}
												else if (el4.getAttribute("allele").equals("G")){
													fnxRefAlleleG++;
													if(maxFnxRefAllele<fnxRefAlleleG){
														maxFnxRefAllele++;
														mostFnxRefAllele=3;
													}
													//buffer.append("3");
													//buffer.append('\t');
												}
												else if (el4.getAttribute("allele").equals("C")){
													fnxRefAlleleC++;
													if(maxFnxRefAllele<fnxRefAlleleC){
														maxFnxRefAllele++;
														mostFnxRefAllele=4;
													}
													//buffer.append("4");
													//buffer.append('\t');
												}
												
												if (el4.getAttribute("residue").equals("A")){
													fnxResidueA++;
													if(maxFnxResidue<fnxResidueA){
														maxFnxResidue++;
														mostFnxResidue=1;
													}
													//buffer.append("1");
													//buffer.append('\t');
												}
												else if (el4.getAttribute("residue").equals("B")){
													fnxResidueB++;
													if(maxFnxResidue<fnxResidueB){
														maxFnxResidue++;
														mostFnxResidue=2;
													}
													//buffer.append("2");
													//buffer.append('\t');
												}
												else if (el4.getAttribute("residue").equals("C")){
													fnxResidueC++;
													if(maxFnxResidue<fnxResidueC){
														maxFnxResidue++;
														mostFnxResidue=3;
													}
													//buffer.append("3");
													//buffer.append('\t');
												}
												else if (el4.getAttribute("residue").equals("D")){
													fnxResidueD++;
													if(maxFnxResidue<fnxResidueD){
														maxFnxResidue++;
														mostFnxResidue=4;
													}
													//buffer.append("4");
													//buffer.append('\t');
												}
												else if (el4.getAttribute("residue").equals("E")){
													fnxResidueE++;
													if(maxFnxResidue<fnxResidueE){
														maxFnxResidue++;
														mostFnxResidue=5;
													}
													//buffer.append("5");
													//buffer.append('\t');
												}
												else if (el4.getAttribute("residue").equals("F")){
													fnxResidueF++;
													if(maxFnxResidue<fnxResidueF){
														maxFnxResidue++;
														mostFnxResidue=6;
													}
													//buffer.append("6");
													//buffer.append('\t');
												}
												else if (el4.getAttribute("residue").equals("G")){
													fnxResidueG++;
													if(maxFnxResidue<fnxResidueG){
														maxFnxResidue++;
														mostFnxResidue=7;
													}
													//buffer.append("7");
													//buffer.append('\t');
												}
												else if (el4.getAttribute("residue").equals("H")){
													fnxResidueH++;
													if(maxFnxResidue<fnxResidueH){
														maxFnxResidue++;
														mostFnxResidue=8;
													}
													//buffer.append("8");
													//buffer.append('\t');
												}
												else if (el4.getAttribute("residue").equals("I")){
													fnxResidueI++;
													if(maxFnxResidue<fnxResidueI){
														maxFnxResidue++;
														mostFnxResidue=9;
													}
													//buffer.append("9");
													//buffer.append('\t');
												}
												else if (el4.getAttribute("residue").equals("K")){
													fnxResidueK++;
													if(maxFnxResidue<fnxResidueK){
														maxFnxResidue++;
														mostFnxResidue=10;
													}
													//buffer.append("10");
													//buffer.append('\t');
												}
												else if (el4.getAttribute("residue").equals("L")){
													fnxResidueL++;
													if(maxFnxResidue<fnxResidueL){
														maxFnxResidue++;
														mostFnxResidue=11;
													}
													//buffer.append("11");
													//buffer.append('\t');
												}
												else if (el4.getAttribute("residue").equals("M")){
													fnxResidueM++;
													if(maxFnxResidue<fnxResidueM){
														maxFnxResidue++;
														mostFnxResidue=12;
													}
													//buffer.append("12");
													//buffer.append('\t');
												}
												else if (el4.getAttribute("residue").equals("N")){
													fnxResidueN++;
													if(maxFnxResidue<fnxResidueN){
														maxFnxResidue++;
														mostFnxResidue=13;
													}
													//buffer.append("13");
													//buffer.append('\t');
												}
												else if (el4.getAttribute("residue").equals("P")){
													fnxResidueP++;
													if(maxFnxResidue<fnxResidueP){
														maxFnxResidue++;
														mostFnxResidue=14;
													}
													//buffer.append("14");
													//buffer.append('\t');
												}
												else if (el4.getAttribute("residue").equals("Q")){
													fnxResidueQ++;
													if(maxFnxResidue<fnxResidueQ){
														maxFnxResidue++;
														mostFnxResidue=15;
													}
													//buffer.append("15");
													//buffer.append('\t');
												}
												else if (el4.getAttribute("residue").equals("R")){
													fnxResidueR++;
													if(maxFnxResidue<fnxResidueR){
														maxFnxResidue++;
														mostFnxResidue=16;
													}
													//buffer.append("16");
													//buffer.append('\t');
												}
												else if (el4.getAttribute("residue").equals("S")){
													fnxResidueS++;
													if(maxFnxResidue<fnxResidueS){
														maxFnxResidue++;
														mostFnxResidue=17;
													}
													//buffer.append("17");
													//buffer.append('\t');
												}
												else if (el4.getAttribute("residue").equals("T")){
													fnxResidueT++;
													if(maxFnxResidue<fnxResidueT){
														maxFnxResidue++;
														mostFnxResidue=18;
													}
													//buffer.append("18");
													//buffer.append('\t');
												}
												else if (el4.getAttribute("residue").equals("V")){
													fnxResidueV++;
													if(maxFnxResidue<fnxResidueV){
														maxFnxResidue++;
														mostFnxResidue=19;
													}
													//buffer.append("19");
													//buffer.append('\t');
												}
												else if (el4.getAttribute("residue").equals("W")){
													fnxResidueW++;
													if(maxFnxResidue<fnxResidueW){
														maxFnxResidue++;
														mostFnxResidue=20;
													}
													//buffer.append("20");
													//buffer.append('\t');
												}
												else if (el4.getAttribute("residue").equals("X")){
													fnxResidueX++;
													if(maxFnxResidue<fnxResidueX){
														maxFnxResidue++;
														mostFnxResidue=21;
													}
													//buffer.append("21");
													//buffer.append('\t');
												}
												else if (el4.getAttribute("residue").equals("Y")){
													fnxResidueY++;
													if(maxFnxResidue<fnxResidueY){
														maxFnxResidue++;
														mostFnxResidue=22;
													}
													//buffer.append("22");
													//buffer.append('\t');
												}
												else if (el4.getAttribute("residue").equals("Z")){
													fnxResidueZ++;
													if(maxFnxResidue<fnxResidueZ){
														maxFnxResidue++;
														mostFnxResidue=23;
													}
													//buffer.append("23");
													//buffer.append('\t');
												}
												mean_aaPosition = (((j)*mean_aaPosition)+Double.parseDouble(el4.getAttribute("aaposition")))/(j+1);
												//buffer.append(el4.getAttribute("aaposition"));
												//buffer.append('\t');
											}
										}
										else {
											//hasFnxSet = false;
										}
									}
								}
								else {
									//hasMapLoc = false;
								}
							}
						}
						else {
							//hasComponent = false;
						}
						NodeList nl2_2 = el1.getElementsByTagName("SnpStat");
						if (nl2_2 != null && nl2_2.getLength() > 0) {
							for (int k = 0; k < nl2_2.getLength(); k++) {
								// get the "SnpStat" element
								if(k>maxSnpStat)
									maxSnpStat=k;

								Element el2 = (Element) nl2_2.item(k);
								// WRITE ITEMS
								mean_chromCount = (((j)*mean_chromCount)+Double.parseDouble(el2.getAttribute("chromCount")))/(j+1);
								//buffer.append(el2.getAttribute("chromCount"));
								//buffer.append('\t');
								mean_placedContigCount = (((j)*mean_placedContigCount)+Double.parseDouble(el2.getAttribute("placedContigCount")))/(j+1);
								//buffer.append(el2.getAttribute("placedContigCount"));
								//buffer.append('\t');
								mean_unplacedContigCount = (((j)*mean_unplacedContigCount)+Double.parseDouble(el2.getAttribute("unplacedContigCount")))/(j+1);
								//buffer.append(el2.getAttribute("unplacedContigCount"));
								//buffer.append('\t');
								mean_seqLocCount = (((j)*mean_seqLocCount)+Double.parseDouble(el2.getAttribute("seqlocCount")))/(j+1);
								//buffer.append(el2.getAttribute("seqlocCount"));
								//buffer.append('\t');
								mean_hapCount = (((j)*mean_hapCount)+Double.parseDouble(el2.getAttribute("hapCount")))/(j+1);
								//buffer.append(el2.getAttribute("hapCount"));
								//buffer.append('\t');
							}
						}
						else {
							//hasSnpStat = false;
						}
					}

					if (glmap.get(mean_groupLabel)!=null){
						buffer.append(glmap.get(mean_groupLabel).toString());
						buffer.append('\t');							
					}
					else {
						buffer.append("0");
						buffer.append('\t');							
					}
					if (mean_componentType > 0.5){
						buffer.append("1");
						buffer.append('\t');
					}
					else{
						buffer.append("0");
						buffer.append('\t');						
					}
					if (accmap.get(mean_accession)!=null){
						buffer.append(accmap.get(mean_accession).toString());
						buffer.append('\t');							
					}
					else {
						buffer.append("0");
						buffer.append('\t');							
					}
					if (chrommap.get(mean_chromosome)!=null){
						buffer.append(chrommap.get(mean_chromosome).toString());
						buffer.append('\t');							
					}
					else {
						buffer.append("0");
						buffer.append('\t');							
					}
					buffer.append(mean_start.toString());
					buffer.append('\t');							
					buffer.append(mean_end.toString());
					buffer.append('\t');							
					buffer.append(mean_length.toString());
					buffer.append('\t');							
					if (mean_orientation > 0.5){
						buffer.append("1");
						buffer.append('\t');
					}
					else{
						buffer.append("0");
						buffer.append('\t');						
					}
					if (gimap.get(mean_gi)!=null){
						buffer.append(gimap.get(mean_gi).toString());
						buffer.append('\t');							
					}
					else {
						buffer.append("0");
						buffer.append('\t');							
					}
					if (grtmap.get(mean_groupTerm)!=null){
						buffer.append(grtmap.get(mean_groupTerm).toString());
						buffer.append('\t');							
					}
					else {
						buffer.append("0");
						buffer.append('\t');							
					}
					if (clmap.get(mean_contigLabel)!=null){
						buffer.append(clmap.get(mean_contigLabel).toString());
						buffer.append('\t');							
					}
					else {
						buffer.append("0");
						buffer.append('\t');							
					}
					if (mean_locType > 0.5){
						buffer.append("1");
						buffer.append('\t');
					}
					else{
						buffer.append("0");
						buffer.append('\t');						
					}
					if (mean_alnQuality > 0.5){
						buffer.append("1");
						buffer.append('\t');
					}
					else{
						buffer.append("0");
						buffer.append('\t');						
					}
					if (mean_orient > 0.5){
						buffer.append("1");
						buffer.append('\t');
					}
					else{
						buffer.append("0");
						buffer.append('\t');						
					}
					buffer.append(mostRefAllele.toString());
					buffer.append('\t');							
					if (genemap.get(mean_geneId)!=null){
						buffer.append(genemap.get(mean_geneId).toString());
						buffer.append('\t');							
					}
					else {
						buffer.append("0");
						buffer.append('\t');							
					}
					if (symmap.get(mean_symbol)!=null){
						buffer.append(symmap.get(mean_symbol).toString());
						buffer.append('\t');							
					}
					else {
						buffer.append("0");
						buffer.append('\t');							
					}
					buffer.append(mean_mrnaVer.toString());
					buffer.append('\t');							
					buffer.append(mean_protVer.toString());
					buffer.append('\t');							
					if (mean_fnxClass < 1.5){
						buffer.append("1");
						buffer.append('\t');
					}
					else if (mean_fnxClass < 2.0){
						buffer.append("2");
						buffer.append('\t');						
					}
					else {
						buffer.append("3");
						buffer.append('\t');						
					}
					buffer.append(mean_readingFrame.toString());
					buffer.append('\t');							
					buffer.append(mostFnxRefAllele.toString());
					buffer.append('\t');							
					buffer.append(mostFnxResidue.toString());
					buffer.append('\t');							
					buffer.append(mean_aaPosition.toString());
					buffer.append('\t');							
					buffer.append(mean_chromCount.toString());
					buffer.append('\t');							
					buffer.append(mean_placedContigCount.toString());
					buffer.append('\t');							
					buffer.append(mean_unplacedContigCount.toString());
					buffer.append('\t');							
					buffer.append(mean_seqLocCount.toString());
					buffer.append('\t');							
					buffer.append(mean_hapCount.toString());
					buffer.append('\t');							
				}
				else {
					for (int r=0 ; r<29 ; r++){
						buffer.append("0");
						buffer.append('\t');													
					}
				}
//end of assembly
//start of PrimarySequence
				NodeList nl1_5 = el.getElementsByTagName("PrimarySequence");
				if (nl1_5 != null && nl1_5.getLength() > 0) {
					String mean_pgi = null;
					String mean_accession = null;
					Double mean_locType = 0.0;
					Double mean_alnQuality = 0.0;
					Double mean_orient = 0.0;
					int refAlleleA=0;
					int refAlleleT=0;
					int refAlleleG=0;
					int refAlleleC=0;
					int maxRefAllele=0;
					Integer mostRefAllele=0;

					for (int j = 0; j < nl1_5.getLength(); j++) {
						// get the "PrimarySequence" element
						if(j>maxPrimarySequence)
							maxPrimarySequence=j;

						Element el1 = (Element) nl1_5.item(j);
						// WRITE ITEMS
						Integer pgiid = 1;
						if (pgimap.containsKey(el.getAttribute("gi"))){
							//buffer.append(pgimap.get(el.getAttribute("gi")).toString());
							//buffer.append('\t');							
						}
						else {
							mean_pgi = el.getAttribute("gi");
							pgimap.put(el.getAttribute("gi"), pgiid);
							//buffer.append(pgimap.get(el.getAttribute("gi")).toString());
							//buffer.append('\t');							
							pgiid++;
						}
						Integer accid = 1;
						if (accmap.containsKey(el.getAttribute("accession"))){
							//buffer.append(accmap.get(el.getAttribute("accession")).toString());
							//buffer.append('\t');							
						}
						else {
							mean_accession = el.getAttribute("accession");
							accmap.put(el.getAttribute("accession"), accid);
							//buffer.append(accmap.get(el.getAttribute("accession")).toString());
							//buffer.append('\t');							
							accid++;
						}

						NodeList nl2_1 = el1.getElementsByTagName("MapLoc");
						if (nl2_1 != null && nl2_1.getLength() > 0) {
							for (int k = 0; k < nl2_1.getLength(); k++) {
								// get the "MapLoc" element
								if(k>maxMapLoc2)
									maxMapLoc2=k;

								Element el2 = (Element) nl2_1.item(k);
								if (el2.getAttribute("locType").equals("exact")){
									mean_locType = (((j)*mean_locType)+1)/(j+1);
									//buffer.append("1");
									//buffer.append('\t');
								}
								else {	
									mean_locType = (((j)*mean_locType)+0)/(j+1);
									//buffer.append("2");
									//buffer.append('\t');
								}
								mean_alnQuality = (((j)*mean_alnQuality)+Double.parseDouble(el2.getAttribute("alnQuality")))/(j+1);
								//buffer.append(el2.getAttribute("alnQuality"));
								//buffer.append('\t');
								if (el2.getAttribute("orient").equals("forward")){
									mean_orient = (((j)*mean_orient)+1)/(j+1);
									//buffer.append("1");
									//buffer.append('\t');											
								}
								else {											
									mean_orient = (((j)*mean_orient)+0)/(j+1);
									//buffer.append("2");											
									//buffer.append('\t');											
								}
								if (el2.getAttribute("refAllele").equals("A")){
									refAlleleA++;
									if(maxRefAllele<refAlleleA){
										maxRefAllele++;
										mostRefAllele=1;
									}
									//buffer.append("1");
									//buffer.append('\t');
								}
								else if (el2.getAttribute("refAllele").equals("T")){
									refAlleleT++;
									if(maxRefAllele<refAlleleT){
										maxRefAllele++;
										mostRefAllele=2;
									}
									//buffer.append("2");
									//buffer.append('\t');
								}
								else if (el2.getAttribute("refAllele").equals("G")){
									refAlleleG++;
									if(maxRefAllele<refAlleleG){
										maxRefAllele++;
										mostRefAllele=3;
									}
									//buffer.append("3");
									//buffer.append('\t');
								}
								else if (el2.getAttribute("refAllele").equals("C")){
									refAlleleC++;
									if(maxRefAllele<refAlleleC){
										maxRefAllele++;
										mostRefAllele=4;
									}
									//buffer.append("4");
									//buffer.append('\t');
								}
							}
						}
					}
					if (pgimap.get(mean_pgi)!=null){
						buffer.append(pgimap.get(mean_pgi).toString());
						buffer.append('\t');							
					}
					else {
						buffer.append("0");
						buffer.append('\t');							
					}
					if (accmap.get(mean_accession)!=null){
						buffer.append(accmap.get(mean_accession).toString());
						buffer.append('\t');							
					}
					else {
						buffer.append("0");
						buffer.append('\t');							
					}
					if (mean_locType > 0.5){
						buffer.append("1");
						buffer.append('\t');
					}
					else{
						buffer.append("0");
						buffer.append('\t');						
					}
					if (mean_alnQuality > 0.5){
						buffer.append("1");
						buffer.append('\t');
					}
					else{
						buffer.append("0");
						buffer.append('\t');						
					}
					if (mean_orient > 0.5){
						buffer.append("1");
						buffer.append('\t');
					}
					else{
						buffer.append("0");
						buffer.append('\t');						
					}
					buffer.append(mostRefAllele.toString());
					buffer.append('\t');							
				}
				else {
					for (int r=0 ; r<6 ; r++){
						buffer.append("0");
						buffer.append('\t');							
					}
				}
//end of PrimarySequence
//start of RsStruct
				NodeList nl1_6 = el.getElementsByTagName("RsStruct");
				if (nl1_6 != null && nl1_6.getLength() > 0) {
					String mean_protAcc = null;
					Double mean_protGi = 0.0;
					Double mean_protLoc = 0.0;
					int protResidueA=0;
					int protResidueB=0;
					int protResidueC=0;
					int protResidueD=0;
					int protResidueE=0;
					int protResidueF=0;
					int protResidueG=0;
					int protResidueH=0;
					int protResidueI=0;
					int protResidueK=0;
					int protResidueL=0;
					int protResidueM=0;
					int protResidueN=0;
					int protResidueP=0;
					int protResidueQ=0;
					int protResidueR=0;
					int protResidueS=0;
					int protResidueT=0;
					int protResidueV=0;
					int protResidueW=0;
					int protResidueX=0;
					int protResidueY=0;
					int protResidueZ=0;
					int maxprotResidue=0;
					Integer mostprotResidue=0;
					int rsResidueA=0;
					int rsResidueB=0;
					int rsResidueC=0;
					int rsResidueD=0;
					int rsResidueE=0;
					int rsResidueF=0;
					int rsResidueG=0;
					int rsResidueH=0;
					int rsResidueI=0;
					int rsResidueK=0;
					int rsResidueL=0;
					int rsResidueM=0;
					int rsResidueN=0;
					int rsResidueP=0;
					int rsResidueQ=0;
					int rsResidueR=0;
					int rsResidueS=0;
					int rsResidueT=0;
					int rsResidueV=0;
					int rsResidueW=0;
					int rsResidueX=0;
					int rsResidueY=0;
					int rsResidueZ=0;
					int maxrsResidue=0;
					Integer mostrsResidue=0;
					String mean_structGi = null;
					Double mean_structLoc = 0.0;
					int structResidueA=0;
					int structResidueB=0;
					int structResidueC=0;
					int structResidueD=0;
					int structResidueE=0;
					int structResidueF=0;
					int structResidueG=0;
					int structResidueH=0;
					int structResidueI=0;
					int structResidueK=0;
					int structResidueL=0;
					int structResidueM=0;
					int structResidueN=0;
					int structResidueP=0;
					int structResidueQ=0;
					int structResidueR=0;
					int structResidueS=0;
					int structResidueT=0;
					int structResidueV=0;
					int structResidueW=0;
					int structResidueX=0;
					int structResidueY=0;
					int structResidueZ=0;
					int maxstructResidue=0;
					Integer moststructResidue=0;
					for (int j = 0; j < nl1_6.getLength(); j++) {
						// get the "RsStruct" element
						if(j>maxRsStruct)
							maxRsStruct=j;

						Element el1 = (Element) nl1_6.item(j);
						// WRITE ITEMS
						Integer paid = 1;
						if (pamap.containsKey(el.getAttribute("protAcc"))){
							//buffer.append(pamap.get(el.getAttribute("protAcc")).toString());
							//buffer.append('\t');							
						}
						else {
							mean_protAcc = el.getAttribute("protAcc");
							pamap.put(el.getAttribute("protAcc"), paid);
							//buffer.append(pamap.get(el.getAttribute("protAcc")).toString());
							//buffer.append('\t');							
							paid++;
						}
						mean_protGi = (((j)*mean_protGi)+Double.parseDouble(el1.getAttribute("protGi")))/(j+1);
						//buffer.append(el1.getAttribute("protGi"));
						//buffer.append('\t');
						mean_protLoc = (((j)*mean_protLoc)+Double.parseDouble(el1.getAttribute("protLoc")))/(j+1);
						//buffer.append(el1.getAttribute("protLoc"));
						//buffer.append('\t');
						if (el1.getAttribute("protResidue").equals("A")){
							protResidueA++;
							if(maxprotResidue<protResidueA){
								maxprotResidue++;
								mostprotResidue=1;
							}
							//buffer.append("1");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("protResidue").equals("B")){
							protResidueB++;
							if(maxprotResidue<protResidueB){
								maxprotResidue++;
								mostprotResidue=2;
							}
							//buffer.append("2");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("protResidue").equals("C")){
							protResidueC++;
							if(maxprotResidue<protResidueC){
								maxprotResidue++;
								mostprotResidue=3;
							}
							//buffer.append("3");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("protResidue").equals("D")){
							protResidueD++;
							if(maxprotResidue<protResidueD){
								maxprotResidue++;
								mostprotResidue=4;
							}
							//buffer.append("4");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("protResidue").equals("E")){
							protResidueE++;
							if(maxprotResidue<protResidueE){
								maxprotResidue++;
								mostprotResidue=5;
							}
							//buffer.append("5");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("protResidue").equals("F")){
							protResidueF++;
							if(maxprotResidue<protResidueF){
								maxprotResidue++;
								mostprotResidue=6;
							}
							//buffer.append("6");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("protResidue").equals("G")){
							protResidueG++;
							if(maxprotResidue<protResidueG){
								maxprotResidue++;
								mostprotResidue=7;
							}
							//buffer.append("7");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("protResidue").equals("H")){
							protResidueH++;
							if(maxprotResidue<protResidueH){
								maxprotResidue++;
								mostprotResidue=8;
							}
							//buffer.append("8");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("protResidue").equals("I")){
							protResidueI++;
							if(maxprotResidue<protResidueI){
								maxprotResidue++;
								mostprotResidue=9;
							}
							//buffer.append("9");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("protResidue").equals("K")){
							protResidueK++;
							if(maxprotResidue<protResidueK){
								maxprotResidue++;
								mostprotResidue=10;
							}
							//buffer.append("10");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("protResidue").equals("L")){
							protResidueL++;
							if(maxprotResidue<protResidueL){
								maxprotResidue++;
								mostprotResidue=11;
							}
							//buffer.append("11");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("protResidue").equals("M")){
							protResidueM++;
							if(maxprotResidue<protResidueM){
								maxprotResidue++;
								mostprotResidue=12;
							}
							//buffer.append("12");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("protResidue").equals("N")){
							protResidueN++;
							if(maxprotResidue<protResidueN){
								maxprotResidue++;
								mostprotResidue=13;
							}
							//buffer.append("13");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("protResidue").equals("P")){
							protResidueP++;
							if(maxprotResidue<protResidueP){
								maxprotResidue++;
								mostprotResidue=14;
							}
							//buffer.append("14");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("protResidue").equals("Q")){
							protResidueQ++;
							if(maxprotResidue<protResidueQ){
								maxprotResidue++;
								mostprotResidue=15;
							}
							//buffer.append("15");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("protResidue").equals("R")){
							protResidueR++;
							if(maxprotResidue<protResidueR){
								maxprotResidue++;
								mostprotResidue=16;
							}
							//buffer.append("16");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("protResidue").equals("S")){
							protResidueS++;
							if(maxprotResidue<protResidueS){
								maxprotResidue++;
								mostprotResidue=17;
							}
							//buffer.append("17");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("protResidue").equals("T")){
							protResidueT++;
							if(maxprotResidue<protResidueT){
								maxprotResidue++;
								mostprotResidue=18;
							}
							//buffer.append("18");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("protResidue").equals("V")){
							protResidueV++;
							if(maxprotResidue<protResidueV){
								maxprotResidue++;
								mostprotResidue=19;
							}
							//buffer.append("19");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("protResidue").equals("W")){
							protResidueW++;
							if(maxprotResidue<protResidueW){
								maxprotResidue++;
								mostprotResidue=20;
							}
							//buffer.append("20");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("protResidue").equals("X")){
							protResidueX++;
							if(maxprotResidue<protResidueX){
								maxprotResidue++;
								mostprotResidue=21;
							}
							//buffer.append("21");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("protResidue").equals("Y")){
							protResidueY++;
							if(maxprotResidue<protResidueY){
								maxprotResidue++;
								mostprotResidue=22;
							}
							//buffer.append("22");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("protResidue").equals("Z")){
							protResidueZ++;
							if(maxprotResidue<protResidueZ){
								maxprotResidue++;
								mostprotResidue=23;
							}
							//buffer.append("23");
							//buffer.append('\t');
						}
						if (el1.getAttribute("rsResidue").equals("A")){
							rsResidueA++;
							if(maxrsResidue<rsResidueA){
								maxrsResidue++;
								mostrsResidue=1;
							}
							//buffer.append("1");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("rsResidue").equals("B")){
							rsResidueB++;
							if(maxrsResidue<rsResidueB){
								maxrsResidue++;
								mostrsResidue=2;
							}
							//buffer.append("2");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("rsResidue").equals("C")){
							rsResidueC++;
							if(maxrsResidue<rsResidueC){
								maxrsResidue++;
								mostrsResidue=3;
							}
							//buffer.append("3");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("rsResidue").equals("D")){
							rsResidueD++;
							if(maxrsResidue<rsResidueD){
								maxrsResidue++;
								mostrsResidue=4;
							}
							//buffer.append("4");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("rsResidue").equals("E")){
							rsResidueE++;
							if(maxrsResidue<rsResidueE){
								maxrsResidue++;
								mostrsResidue=5;
							}
							//buffer.append("5");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("rsResidue").equals("F")){
							rsResidueF++;
							if(maxrsResidue<rsResidueF){
								maxrsResidue++;
								mostrsResidue=6;
							}
							//buffer.append("6");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("rsResidue").equals("G")){
							rsResidueG++;
							if(maxrsResidue<rsResidueG){
								maxrsResidue++;
								mostrsResidue=7;
							}
							//buffer.append("7");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("rsResidue").equals("H")){
							rsResidueH++;
							if(maxrsResidue<rsResidueH){
								maxrsResidue++;
								mostrsResidue=8;
							}
							//buffer.append("8");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("rsResidue").equals("I")){
							rsResidueI++;
							if(maxrsResidue<rsResidueI){
								maxrsResidue++;
								mostrsResidue=9;
							}
							//buffer.append("9");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("rsResidue").equals("K")){
							rsResidueK++;
							if(maxrsResidue<rsResidueK){
								maxrsResidue++;
								mostrsResidue=10;
							}
							//buffer.append("10");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("rsResidue").equals("L")){
							rsResidueL++;
							if(maxrsResidue<rsResidueL){
								maxrsResidue++;
								mostrsResidue=11;
							}
							//buffer.append("11");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("rsResidue").equals("M")){
							rsResidueM++;
							if(maxrsResidue<rsResidueM){
								maxrsResidue++;
								mostrsResidue=12;
							}
							//buffer.append("12");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("rsResidue").equals("N")){
							rsResidueN++;
							if(maxrsResidue<rsResidueN){
								maxrsResidue++;
								mostrsResidue=13;
							}
							//buffer.append("13");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("rsResidue").equals("P")){
							rsResidueP++;
							if(maxrsResidue<rsResidueP){
								maxrsResidue++;
								mostrsResidue=14;
							}
							//buffer.append("14");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("rsResidue").equals("Q")){
							rsResidueQ++;
							if(maxrsResidue<rsResidueQ){
								maxrsResidue++;
								mostrsResidue=15;
							}
							//buffer.append("15");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("rsResidue").equals("R")){
							rsResidueR++;
							if(maxrsResidue<rsResidueR){
								maxrsResidue++;
								mostrsResidue=16;
							}
							//buffer.append("16");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("rsResidue").equals("S")){
							rsResidueS++;
							if(maxrsResidue<rsResidueS){
								maxrsResidue++;
								mostrsResidue=17;
							}
							//buffer.append("17");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("rsResidue").equals("T")){
							rsResidueT++;
							if(maxrsResidue<rsResidueT){
								maxrsResidue++;
								mostrsResidue=18;
							}
							//buffer.append("18");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("rsResidue").equals("V")){
							rsResidueV++;
							if(maxrsResidue<rsResidueV){
								maxrsResidue++;
								mostrsResidue=19;
							}
							//buffer.append("19");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("rsResidue").equals("W")){
							rsResidueW++;
							if(maxrsResidue<rsResidueW){
								maxrsResidue++;
								mostrsResidue=20;
							}
							//buffer.append("20");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("rsResidue").equals("X")){
							rsResidueX++;
							if(maxrsResidue<rsResidueX){
								maxrsResidue++;
								mostrsResidue=21;
							}
							//buffer.append("21");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("rsResidue").equals("Y")){
							rsResidueY++;
							if(maxrsResidue<rsResidueY){
								maxrsResidue++;
								mostrsResidue=22;
							}
							//buffer.append("22");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("rsResidue").equals("Z")){
							rsResidueZ++;
							if(maxrsResidue<rsResidueZ){
								maxrsResidue++;
								mostrsResidue=23;
							}
							//buffer.append("23");
							//buffer.append('\t');

						}
						Integer sgiid = 1;
						if (sgimap.containsKey(el.getAttribute("structGi"))){
							//buffer.append(sgimap.get(el.getAttribute("structGi")).toString());
							//buffer.append('\t');							
						}
						else {
							mean_structGi = el.getAttribute("structGi");
							sgimap.put(el.getAttribute("structGi"), sgiid);
							//buffer.append(sgimap.get(el.getAttribute("structGi")).toString());
							//buffer.append('\t');							
							sgiid++;
						}
						mean_structLoc = (((j)*mean_structLoc)+Double.parseDouble(el1.getAttribute("structLoc")))/(j+1);
						//buffer.append(el1.getAttribute("structLoc"));
						//buffer.append('\t');
						if (el1.getAttribute("structResidue").equals("A")){
							structResidueA++;
							if(maxstructResidue<structResidueA){
								maxstructResidue++;
								moststructResidue=1;
							}
							//buffer.append("1");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("structResidue").equals("B")){
							structResidueB++;
							if(maxstructResidue<structResidueB){
								maxstructResidue++;
								moststructResidue=2;
							}
							//buffer.append("2");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("structResidue").equals("C")){
							structResidueC++;
							if(maxstructResidue<structResidueC){
								maxstructResidue++;
								moststructResidue=3;
							}
							//buffer.append("3");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("structResidue").equals("D")){
							structResidueD++;
							if(maxstructResidue<structResidueD){
								maxstructResidue++;
								moststructResidue=4;
							}
							//buffer.append("4");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("structResidue").equals("E")){
							structResidueE++;
							if(maxstructResidue<structResidueE){
								maxstructResidue++;
								moststructResidue=5;
							}
							//buffer.append("5");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("structResidue").equals("F")){
							structResidueF++;
							if(maxstructResidue<structResidueF){
								maxstructResidue++;
								moststructResidue=6;
							}
							//buffer.append("6");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("structResidue").equals("G")){
							structResidueG++;
							if(maxstructResidue<structResidueG){
								maxstructResidue++;
								moststructResidue=7;
							}
							//buffer.append("7");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("structResidue").equals("H")){
							structResidueH++;
							if(maxstructResidue<structResidueH){
								maxstructResidue++;
								moststructResidue=8;
							}
							//buffer.append("8");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("structResidue").equals("I")){
							structResidueI++;
							if(maxstructResidue<structResidueI){
								maxstructResidue++;
								moststructResidue=9;
							}
							//buffer.append("9");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("structResidue").equals("K")){
							structResidueK++;
							if(maxstructResidue<structResidueK){
								maxstructResidue++;
								moststructResidue=10;
							}
							//buffer.append("10");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("structResidue").equals("L")){
							structResidueL++;
							if(maxstructResidue<structResidueL){
								maxstructResidue++;
								moststructResidue=11;
							}
							//buffer.append("11");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("structResidue").equals("M")){
							structResidueM++;
							if(maxstructResidue<structResidueM){
								maxstructResidue++;
								moststructResidue=12;
							}
							//buffer.append("12");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("structResidue").equals("N")){
							structResidueN++;
							if(maxstructResidue<structResidueN){
								maxstructResidue++;
								moststructResidue=13;
							}
							//buffer.append("13");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("structResidue").equals("P")){
							structResidueP++;
							if(maxstructResidue<structResidueP){
								maxstructResidue++;
								moststructResidue=14;
							}
							//buffer.append("14");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("structResidue").equals("Q")){
							structResidueQ++;
							if(maxstructResidue<structResidueQ){
								maxstructResidue++;
								moststructResidue=15;
							}
							//buffer.append("15");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("structResidue").equals("R")){
							structResidueR++;
							if(maxstructResidue<structResidueR){
								maxstructResidue++;
								moststructResidue=16;
							}
							//buffer.append("16");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("structResidue").equals("S")){
							structResidueS++;
							if(maxstructResidue<structResidueS){
								maxstructResidue++;
								moststructResidue=17;
							}
							//buffer.append("17");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("structResidue").equals("T")){
							structResidueT++;
							if(maxstructResidue<structResidueT){
								maxstructResidue++;
								moststructResidue=18;
							}
							//buffer.append("18");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("structResidue").equals("V")){
							structResidueV++;
							if(maxstructResidue<structResidueV){
								maxstructResidue++;
								moststructResidue=19;
							}
							//buffer.append("19");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("structResidue").equals("W")){
							structResidueW++;
							if(maxstructResidue<structResidueW){
								maxstructResidue++;
								moststructResidue=20;
							}
							//buffer.append("20");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("structResidue").equals("X")){
							structResidueX++;
							if(maxstructResidue<structResidueX){
								maxstructResidue++;
								moststructResidue=21;
							}
							//buffer.append("21");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("structResidue").equals("Y")){
							structResidueY++;
							if(maxstructResidue<structResidueY){
								maxstructResidue++;
								moststructResidue=22;
							}
							//buffer.append("22");
							//buffer.append('\t');
						}
						else if (el1.getAttribute("structResidue").equals("Z")){
							structResidueZ++;
							if(maxstructResidue<structResidueZ){
								maxstructResidue++;
								moststructResidue=23;
							}
							//buffer.append("23");
							//buffer.append('\t');
						}
					}
					if (pamap.get(mean_protAcc)!=null){
						buffer.append(pamap.get(mean_protAcc).toString());
						buffer.append('\t');							
					}
					else {
						buffer.append("0");
						buffer.append('\t');							
					}
					buffer.append(mean_protGi.toString());
					buffer.append('\t');							
					buffer.append(mean_protLoc.toString());
					buffer.append('\t');							
					buffer.append(mostprotResidue.toString());
					buffer.append('\t');							
					buffer.append(mostrsResidue.toString());
					buffer.append('\t');							
					if (sgimap.get(mean_structGi)!=null){
						buffer.append(sgimap.get(mean_structGi).toString());
						buffer.append('\t');							
					}
					else {
						buffer.append("0");
						buffer.append('\t');							
					}
					buffer.append(mean_structLoc.toString());
					buffer.append('\t');							
					buffer.append(moststructResidue.toString());
					buffer.append('\t');							
				}
				else {
					for (int r=0 ; r<8 ; r++){
						buffer.append("0");
						buffer.append('\t');							
					}
				}
//end of RsStruct
//start of hgvs
				NodeList nl1_7 = el.getElementsByTagName("hgvs");
				if (nl1_7 != null && nl1_7.getLength() > 0) {
					String mean_hgvs = null;
					for (int j = 0; j < nl1_7.getLength(); j++) {
						// get the "hgvs" element
						if(j>maxhgvs)
							maxhgvs=j;

						//Element el1 = (Element) nl1_7.item(j);
						// WRITE ITEMS
						Integer hgvsid = 1;
						if (hgvsmap.containsKey(getTextValue(el, "hgvs"))){
//							buffer.append(hgvsmap.get(getTextValue(el, "hgvs").toString()));
//							buffer.append('\t');							
						}
						else {
							mean_hgvs = getTextValue(el, "hgvs");
							hgvsmap.put(getTextValue(el, "hgvs"), hgvsid);
//							buffer.append(hgvsmap.get(getTextValue(el, "hgvs").toString()));
//							buffer.append('\t');							
							hgvsid++;
						}
//						buffer.append('\t');
					}
					if (hgvsmap.get(mean_hgvs)!=null){
						buffer.append(hgvsmap.get(mean_hgvs).toString());
						buffer.append('\t');							
					}
					else {
						buffer.append("0");
						buffer.append('\t');							
					}					
				}
				else{
					buffer.append("0");
					buffer.append('\t');							
				}
//end of hgvs
//start of AlleleOrigin
				NodeList nl1_8 = el.getElementsByTagName("AlleleOrigin");
				if (nl1_8 != null && nl1_8.getLength() > 0) {
					int alleleOriginA = 0;
					int alleleOriginT = 0;
					int alleleOriginG = 0;
					int alleleOriginC = 0;
					int maxalleleOrigin = 0;
					Integer mostalleleOrigin = 0;
					for (int j = 0; j < nl1_8.getLength(); j++) {
						// get the "AlleleOrigin" element
						if(j>maxAlleleOrigin)
							maxAlleleOrigin=j;

						Element el1 = (Element) nl1_8.item(j);
						// WRITE ITEMS
						if (el1.getAttribute("allele").equals("A")){
							alleleOriginA++;
							if(maxalleleOrigin<alleleOriginA){
								maxalleleOrigin++;
								mostalleleOrigin=1;
							}
//							buffer.append("1");
//							buffer.append('\t');
						}
						else if (el1.getAttribute("allele").equals("T")){
							alleleOriginT++;
							if(maxalleleOrigin<alleleOriginT){
								maxalleleOrigin++;
								mostalleleOrigin=2;
							}
//							buffer.append("2");
//							buffer.append('\t');
						}
						else if (el1.getAttribute("allele").equals("G")){
							alleleOriginG++;
							if(maxalleleOrigin<alleleOriginG){
								maxalleleOrigin++;
								mostalleleOrigin=3;
							}
//							buffer.append("3");
//							buffer.append('\t');
						}
						else if (el1.getAttribute("allele").equals("C")){
							alleleOriginC++;
							if(maxalleleOrigin<alleleOriginC){
								maxalleleOrigin++;
								mostalleleOrigin=4;
							}
//							buffer.append("4");
//							buffer.append('\t');
						}
//						buffer.append(getTextValue(el, "AlleleOrigin"));
//						buffer.append('\t');
					}
					buffer.append(mostalleleOrigin.toString());
					buffer.append('\t');							
				}
				else{
					buffer.append("0");
					buffer.append('\t');												
				}
//end of AlleleOrigin


//finish xml parsing and continue				
				
//				System.out.print(".");
				writer.println(buffer.toString());
//				writer.newLine();
				System.out.println(buffer.toString());
				buffer.delete(0, buffer.length());
			}
		}
		System.out.println("max Ss="+maxSs);
		System.out.println("maxSequence="+maxSequence);
		System.out.println("maxAssembly="+maxAssembly);
		System.out.println("maxComponent="+maxComponent);
		System.out.println("maxMapLoc="+maxMapLoc);
		System.out.println("maxFxnSet="+maxFxnSet);
		System.out.println("maxSnpStat="+maxSnpStat);
		System.out.println("maxPrimarySequence="+maxPrimarySequence);
		System.out.println("maxMapLoc2="+maxMapLoc2);
		System.out.println("maxRsStruct="+maxRsStruct);
		System.out.println("maxhgvs="+maxhgvs);
		System.out.println("maxAlleleOrigin="+maxAlleleOrigin);
	}

	private String getTextValue(Element ele, String tagName) {
		String textVal = null;
		NodeList nl = ele.getElementsByTagName(tagName);
		if (nl != null && nl.getLength() > 0) {
			Element el = (Element) nl.item(0);
			textVal = el.getFirstChild().getNodeValue();
		}

		return textVal;
	}

	private static String readFile(String path) throws IOException {
		FileInputStream stream = new FileInputStream(new File(path));
		try {
			FileChannel fc = stream.getChannel();
			MappedByteBuffer bb = fc.map(FileChannel.MapMode.READ_ONLY, 0, fc.size());
			/* Instead of using default, pass in a decoder. */
			return Charset.defaultCharset().decode(bb).toString();
		} finally {
			stream.close();
		}
	}

//	@SuppressWarnings("unused")
	public static void main(String[] args) throws Exception {
		xmlSNPParser xmlparser = new xmlSNPParser ();
		String xml = readFile(fileToPath("../data/vulvovaginal.xml"));
		System.out.print(xml);
		System.out.print("\n\n\n");
		
		xmlparser.parseXML(xml);

		// close the file
		writer.close();

		System.out.print("\n\n\n");
	}

	public static String fileToPath(String filename) throws UnsupportedEncodingException{
		URL url = xmlSNPParser.class.getResource(filename);
		 return java.net.URLDecoder.decode(url.getPath(),"UTF-8");
	}
	

}
